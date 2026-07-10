module TreeSitterManager
  # Preprocess tree-sitter query files (.scm) by:
  # - Resolving `; inherits <lang>` directives
  # - Stripping platform-specific sections
  # - Rewriting Neovim-style predicates to tree-sitter format
  # - Converting Lua patterns to regex in match predicates
  module QueryPreprocessor
    # Process highlight queries with inherits support
    def self.process_highlights_with_inherits(strip_comment : String, nvim_like : Bool, lang_name : String, base_dir : String) : String
      process_with_inherits(base_dir, lang_name, "highlights.scm", strip_comment,
        nvim_like ? ->process_highlights(Sexpr::Nodes) : nil)
    end

    # Process injection queries with inherits support
    def self.process_injections_with_inherits(strip_comment : String, nvim_like : Bool, lang_name : String, base_dir : String) : String
      process_with_inherits(base_dir, lang_name, "injections.scm", strip_comment,
        nvim_like ? ->process_injections(Sexpr::Nodes) : nil)
    end

    # Process locals queries with inherits support
    def self.process_locals_with_inherits(strip_comment : String, nvim_like : Bool, lang_name : String, base_dir : String) : String
      process_with_inherits(base_dir, lang_name, "locals.scm", strip_comment,
        nvim_like ? ->process_locals(Sexpr::Nodes) : nil)
    end

    # Main processing pipeline
    def self.process(src : String, processor : (Sexpr::Nodes ->)? = nil, strip_comment : String = "crates.io") : String
      # Parse S-expressions
      result = Sexpr.from_slice_multi(src)
      raise "Failed to parse queries: #{result.errors}" unless result.success?

      # Convert to owned nodes (Sexpr::Nodes)
      nodes = result.unwrap

      # Pipeline
      nodes = group_root_level_captures(nodes)
      strip(nodes, strip_comment)
      remove_comments(nodes)
      processor.try(&.call(nodes))
      nodes = ungroup_root_level_captures(nodes)

      nodes.children.map(&.to_s).join("\n")
    end

    private def self.process_with_inherits(base_dir : String, lang_name : String, filename : String, strip_comment : String, processor : (Sexpr::Nodes ->)?) : String
      queries = read_queries(base_dir, lang_name, filename)
      process(queries, processor, strip_comment)
    rescue ex
      "warning: failed to process #{base_dir}/#{lang_name}/#{filename}: #{ex.message}"
    end

    # Read a query file with `; inherits` resolution
    private def self.read_queries(base_dir : String, lang_name : String, filename : String) : String
      path = File.join(base_dir, lang_name, filename)
      queries = begin
        File.read(path)
      rescue File::NotFoundError
        ""
      end

      # Resolve `; inherits <lang>` directives
      queries.gsub(/;+\s*inherits\s*:?\s*([a-z_,() -]+)\s*/im) do |match|
        langs = $1
        langs.split(',').map { |lang|
          "\n#{read_queries(base_dir, lang.strip, filename)}\n"
        }.join
      end
    end

    # Group root-level captures: patterns followed by @captures get grouped
    private def self.group_root_level_captures(nodes : Sexpr::Nodes) : Sexpr::Nodes
      new_children = Array(Sexpr::Node).new
      iter = nodes.children.dup
      i = 0

      while i < iter.size
        node = iter[i]
        case node
        when Sexpr::ListNode, Sexpr::GroupNode, Sexpr::StringNode
          group = Array(Sexpr::Node).new
          group << node
          i += 1
          while i < iter.size && iter[i].is_a?(Sexpr::AtomNode)
            group << iter[i]
            i += 1
          end
          if group.size == 1
            new_children << group[0]
          else
            new_children << Sexpr::ListNode.new(Sexpr::Nodes.new(group))
          end
        else
          new_children << node
          i += 1
        end
      end

      Sexpr::Nodes.new(new_children)
    end

    # Ungroup root-level captures: reverse of grouping
    private def self.ungroup_root_level_captures(nodes : Sexpr::Nodes) : Sexpr::Nodes
      new_children = Array(Sexpr::Node).new

      nodes.children.each do |node|
        case node
        when Sexpr::ListNode
          list = node.unwrap_list
          if list.children.empty?
            next
          end
          first = list.children[0]?
          if first && (first.is_a?(Sexpr::ListNode) || first.is_a?(Sexpr::GroupNode) || first.is_a?(Sexpr::StringNode)) &&
             list.children[1..].all? { |c| c.is_a?(Sexpr::AtomNode) }
            list.children.each { |c| new_children << c }
          else
            new_children << node
          end
        else
          new_children << node
        end
      end

      Sexpr::Nodes.new(new_children)
    end

    # Remove comments from the tree
    private def self.remove_comments(nodes : Sexpr::Nodes) : Nil
      nodes.children.reject! { |n| n.is_a?(Sexpr::CommentNode) }
      nodes.children.each do |node|
        case node
        when Sexpr::ListNode
          remove_comments(node.unwrap_list)
        when Sexpr::GroupNode
          remove_comments(node.unwrap_group)
        end
      end
    end

    # Strip patterns that follow a skip comment
    private def self.strip(nodes : Sexpr::Nodes, skip_comment : String) : Nil
      delete_next = false
      nodes.children.reject! do |node|
        delete_this = delete_next
        if (comment = node.as?(Sexpr::CommentNode)) && comment.value == skip_comment
          delete_next = true
        else
          delete_next = false
        end
        delete_this
      end

      nodes.children.each do |node|
        case node
        when Sexpr::ListNode
          strip(node.unwrap_list, skip_comment)
        when Sexpr::GroupNode
          strip(node.unwrap_group, skip_comment)
        end
      end
    end

    # Process highlights: replace predicates only
    private def self.process_highlights(nodes : Sexpr::Nodes) : Nil
      nodes.children.each { |n| _replace_predicates(n) }
    end

    # Process injections: replace injection captures + predicates
    private def self.process_injections(nodes : Sexpr::Nodes) : Nil
      nodes.children.each do |n|
        replace_injection_captures(n)
        _replace_predicates(n)
      end
    end

    # Process locals: replace locals captures + predicates
    private def self.process_locals(nodes : Sexpr::Nodes) : Nil
      nodes.children.each do |n|
        replace_locals_captures(n)
        _replace_predicates(n)
      end
    end

    # Replace Neovim-style predicates with tree-sitter equivalents (public for testing)
    def self.replace_predicates(node : Sexpr::Node) : Nil
      _replace_predicates(node)
    end

    private def self._replace_predicates(node : Sexpr::Node) : Nil
      case node
      when Sexpr::ListNode, Sexpr::GroupNode
        list = node.is_a?(Sexpr::ListNode) ? node.as(Sexpr::ListNode).unwrap_list : node.as(Sexpr::GroupNode).unwrap_group
        return if list.children.empty?

        first = list.children[0]
        if (first_atom = first.as?(Sexpr::AtomNode)) && first_atom.value[0]? == '#'
          pred_name = first_atom.value
          is_not = pred_name.starts_with?("#not-")
          match_pred_name = is_not ? "#not-match?" : "#match?"

          case pred_name
          when "#gsub!"
            rewrite_gsub(list)
          when "#lua-match?", "#not-lua-match?"
            rewrite_lua_match(list, match_pred_name)
          when "#any-of?", "#not-any-of?"
            rewrite_any_of(list, match_pred_name)
          when "#contains?", "#not-contains?"
            list.children[0] = Sexpr::AtomNode.new(match_pred_name)
          end
        else
          list.children.each { |child| _replace_predicates(child) }
        end
      end
    end

    private def self.rewrite_gsub(list : Sexpr::Nodes) : Nil
      list.children[0] = Sexpr::AtomNode.new("#replace!")
      # Convert Lua pattern to regex
      lua_pat = list.children[2].unwrap_string
      regex = LuaPattern.to_regex(LuaPattern.parse(lua_pat), false, false)
      list.children[2] = Sexpr::StringNode.new(regex)
      # Convert replacement %1 → ${1}
      replacement = list.children[3].unwrap_string.gsub("%%", "%").gsub("$", "$$")
      replacement = replacement.gsub(/%(\d)/) { "${#{$1}}" }
      list.children[3] = Sexpr::StringNode.new(replacement)
      # Truncate to 4 elements
      while list.children.size > 4
        list.children.pop
      end
    end

    private def self.rewrite_lua_match(list : Sexpr::Nodes, match_pred_name : String) : Nil
      list.children[0] = Sexpr::AtomNode.new(match_pred_name)
      lua_pat = list.children[2].unwrap_string
      regex = LuaPattern.to_regex(LuaPattern.parse(lua_pat), false, false)
      list.children[2] = Sexpr::StringNode.new(regex)
      while list.children.size > 3
        list.children.pop
      end
    end

    private def self.rewrite_any_of(list : Sexpr::Nodes, match_pred_name : String) : Nil
      list.children[0] = Sexpr::AtomNode.new(match_pred_name)
      args = list.children[2..].map(&.unwrap_string)
      escaped = args.map { |a| Regex.escape(a) }
      list.children[2] = Sexpr::StringNode.new("^(#{escaped.join("|")})$")
      while list.children.size > 3
        list.children.pop
      end
    end

    # Rewrite nvim-style locals captures
    private def self.replace_locals_captures(node : Sexpr::Node) : Nil
      case node
      when Sexpr::AtomNode
        case node.value
        when "@scope"     then node.as(Sexpr::AtomNode).value = "@local.scope"
        when "@reference" then node.as(Sexpr::AtomNode).value = "@local.reference"
        else
          if node.value == "@definition" || node.value.starts_with?("@definition.") || node.value.starts_with?("@local.definition.")
            node.as(Sexpr::AtomNode).value = "@local.definition"
          end
        end
      when Sexpr::ListNode, Sexpr::GroupNode
        list = node.is_a?(Sexpr::ListNode) ? node.as(Sexpr::ListNode).unwrap_list : node.as(Sexpr::GroupNode).unwrap_group
        list.children.each { |child| replace_locals_captures(child) }
      end
    end

    # Rewrite nvim-style injection captures
    private def self.replace_injection_captures(node : Sexpr::Node) : Nil
      _replace_injection_captures(node, 0)
    end

    private def self._replace_injection_captures(node : Sexpr::Node, pred_count : Int32) : {Bool, Sexpr::Node?}
      case node
      when Sexpr::AtomNode
        val = node.value
        if val[0]? == '@' && !val[1..]?.try(&.starts_with?('_'))
          capture = val[1..]
          case capture
          when "injection.content", "injection.language"
            {false, nil}
          when "content"
            node.as(Sexpr::AtomNode).value = "@injection.content"
            {false, nil}
          when "language"
            node.as(Sexpr::AtomNode).value = "@injection.language"
            {false, nil}
          when "combined"
            children = Array(Sexpr::Node).new
            children << Sexpr::AtomNode.new("#set!")
            children << Sexpr::AtomNode.new("injection.combined")
            {false, Sexpr::ListNode.new(Sexpr::Nodes.new(children))}
          else
            if pred_count == 0
              children = Array(Sexpr::Node).new
              children << Sexpr::AtomNode.new("#set!")
              children << Sexpr::AtomNode.new("injection.language")
              children << Sexpr::StringNode.new(capture)
              {false, Sexpr::ListNode.new(Sexpr::Nodes.new(children))}
            end
            node.as(Sexpr::AtomNode).value = "@injection.content"
            {false, nil}
          end
        elsif val[0]? == '#'
          {true, nil}
        else
          {false, nil}
        end
      when Sexpr::ListNode, Sexpr::GroupNode
        list = node.is_a?(Sexpr::ListNode) ? node.as(Sexpr::ListNode).unwrap_list : node.as(Sexpr::GroupNode).unwrap_group
        is_pred = false
        insertions = Array({Int32, Sexpr::Node}).new

        list.children.each_with_index do |child, i|
          pred_result = _replace_injection_captures(child, pred_count)
          if pred_result[0]
            pred_count += 1
            is_pred = true
          end
          if extra = pred_result[1]
            insertions << {i + 1 + insertions.size, extra}
          end
        end

        insertions.each do |(idx, extra)|
          list.children.insert(idx, extra)
        end

        {is_pred, nil}
      else
        {false, nil}
      end
    end
  end
end
