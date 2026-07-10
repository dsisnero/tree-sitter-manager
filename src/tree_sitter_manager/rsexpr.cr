module TreeSitterManager
  # S-expression parser for tree-sitter query files (.scm format).
  #
  # Parses parenthesized lists `( )`, bracketed groups `[ ]`,
  # quoted strings `"..."`, atoms, and line comments `; ...`.
  module Sexpr
    # Error types for parsing failures
    enum Error
      MissingClosingParen
      ExtraClosingParen
      EmptyInput
      ExtraSexprs
    end

    # Result type — either a value or a list of errors
    struct Result(T)
      getter value : T?
      getter errors : Array(Error)?

      def initialize(@value : T? = nil, @errors : Array(Error)? = nil)
      end

      def success? : Bool
        @errors.nil? && !@value.nil?
      end

      def failure? : Bool
        !success?
      end

      def unwrap : T
        raise "unwrap on failure: #{@errors}" unless success?
        @value.not_nil!
      end
    end

    # Base type for all S-expression nodes
    abstract class Node
      def to_s(io : IO) : Nil
        format(io, false, 0, 2)
      end

      def to_s_pretty(indent : Int32 = 2) : String
        String.build { |io| format(io, true, 0, indent) }
      end

      abstract def format(io : IO, pretty : Bool, level : Int32, indent_width : Int32) : Nil

      def list? : Nodes?
        nil
      end

      def group? : Nodes?
        nil
      end

      def string? : ::String?
        nil
      end

      def atom? : ::String?
        nil
      end

      def comment? : ::String?
        nil
      end

      def unwrap_list : Nodes
        raise "called unwrap_list on a #{self.class}"
      end

      def unwrap_group : Nodes
        raise "called unwrap_group on a #{self.class}"
      end

      def unwrap_string : ::String
        raise "called unwrap_string on a #{self.class}"
      end

      def unwrap_atom : ::String
        raise "called unwrap_atom on a #{self.class}"
      end
    end

    # Wrapper around Array(Node) with display and iteration
    class Nodes
      include Enumerable(Node)

      @children : Array(Node)

      getter children : Array(Node)

      def initialize
        @children = Array(Node).new
      end

      def initialize(@children : Array(Node))
      end

      def each(& : Node ->) : Nil
        @children.each { |child| yield child }
      end

      def size : Int32
        @children.size
      end

      def empty? : Bool
        @children.empty?
      end

      def [](index : Int) : Node
        @children[index]
      end

      def []?(index : Int) : Node?
        @children[index]?
      end

      def first? : Node?
        @children[0]?
      end

      def push(node : Node) : Nil
        @children.push(node)
      end

      def <<(node : Node) : Nil
        @children << node
      end

      def swap_remove(index : Int) : Node
        @children.delete_at(index)
      end

      def delete_at(index : Int) : Node
        @children.delete_at(index)
      end

      def insert(index : Int, node : Node) : Nil
        @children.insert(index, node)
      end

      def retain!(& : Node -> Bool) : Nil
        @children.select! { |n| yield n }
      end

      def reject!(& : Node -> Bool) : Nil
        @children.reject! { |n| yield n }
      end

      def pop : Node?
        @children.pop?
      end
    end

    class ListNode < Node
      property children : Nodes

      def initialize(@children : Nodes = Nodes.new)
      end

      def list? : Nodes
        @children
      end

      def unwrap_list : Nodes
        @children
      end

      def format(io : IO, pretty : Bool, level : Int32, indent_width : Int32) : Nil
        Sexpr.format_nodes(@children, io, pretty, level, indent_width, '(', ')')
      end
    end

    class GroupNode < Node
      property children : Nodes

      def initialize(@children : Nodes = Nodes.new)
      end

      def group? : Nodes
        @children
      end

      def unwrap_group : Nodes
        @children
      end

      def format(io : IO, pretty : Bool, level : Int32, indent_width : Int32) : Nil
        Sexpr.format_nodes(@children, io, pretty, level, indent_width, '[', ']')
      end
    end

    class StringNode < Node
      property value : String

      def initialize(@value : String)
      end

      def string? : String
        @value
      end

      def unwrap_string : String
        @value
      end

      def format(io : IO, pretty : Bool, level : Int32, indent_width : Int32) : Nil
        escaped = @value.gsub("\\", "\\\\").gsub("\"", "\\\"")
        io << '"' << escaped << '"'
      end
    end

    class AtomNode < Node
      property value : String

      def initialize(@value : String)
      end

      def atom? : String
        @value
      end

      def unwrap_atom : String
        @value
      end

      def format(io : IO, pretty : Bool, level : Int32, indent_width : Int32) : Nil
        io << @value
      end
    end

    class CommentNode < Node
      getter value : String

      def initialize(@value : String)
      end

      def comment? : String
        @value
      end

      def format(io : IO, pretty : Bool, level : Int32, indent_width : Int32) : Nil
        if pretty
          io << @value
        end
      end
    end

    # Shared formatting for List/Group nodes
    def self.format_nodes(
      nodes : Nodes, io : IO, pretty : Bool, level : Int32, indent_width : Int32,
      open : Char, close : Char,
    ) : Nil
      if !pretty
        io << open
        nodes.children.each_with_index do |child, i|
          child.format(io, false, level + 1, indent_width)
          io << ' ' if i < nodes.children.size - 1
        end
        io << close
      else
        first_child = nodes.children[0]?

        if (atom = first_child.try(&.atom?)) && atom.starts_with?('#') && nodes.children.size <= 7
          # Keep predicate lists on one line
          io << open
          nodes.children.each_with_index do |child, i|
            child.format(io, false, level + 1, indent_width)
            io << ' ' if i < nodes.children.size - 1
          end
          io << close
        elsif nodes.children.empty?
          io << open << close
        elsif nodes.children.size == 1
          child = nodes.children[0]
          if child.list? || child.group?
            inner = child.list? ? child.unwrap_list : child.unwrap_group
            if inner.children.empty?
              io << open << close
            else
              next_level = level + 1
              io << open
              io << '\n'
              io << (" " * indent_width * next_level)
              child.format(io, true, next_level, indent_width)
              io << '\n'
              io << (" " * indent_width * level)
              io << close
            end
          else
            io << open
            child.format(io, false, level + 1, indent_width)
            io << close
          end
        else
          next_level = level + 1
          indent = " " * indent_width * next_level

          io << open

          # Handle query captures: keep string/atom + @capture on same line
          if (first = first_child) && (first.atom? ? first.atom?.not_nil!.starts_with?('@') : first.string?)
            io << '\n' << indent
            first.format(io, true, next_level, indent_width)
            nodes.children[1..].each do |child|
              if (child_atom = child.atom?) && child_atom.starts_with?('@')
                io << ' ' << child_atom
              elsif child.list? || child.group?
                io << '\n' << indent
                child.format(io, true, next_level, indent_width)
              else
                io << '\n' << indent
                child.format(io, true, next_level, indent_width)
              end
            end
          else
            nodes.children.each do |child|
              io << '\n' << indent
              child.format(io, true, next_level, indent_width)
            end
          end

          io << '\n'
          io << (" " * indent_width * level)
          io << close
        end
      end
    end

    # Token types produced by the lexer
    enum TokenType
      LParen
      RParen
      LBrack
      RBrack
      String
      Atom
      Comment
    end

    record Token, type : TokenType, value : String = ""

    # Lexer: converts raw string into tokens
    module Lexer
      WHITESPACE  = Set{' ', '\t', '\r', '\n'}
      NOT_IN_ATOM = Set{'(', ')', '[', ']', '"'}

      def self.lex(input : String) : Array(Token)
        tokens = Array(Token).new
        i = 0

        while i < input.size
          ch = input[i]
          if WHITESPACE.includes?(ch)
            i += 1
          elsif ch == ';'
            start = i
            while i < input.size && input[i] != '\r' && input[i] != '\n'
              i += 1
            end
            tokens << Token.new(TokenType::Comment, input[start...i])
          elsif ch == '('
            tokens << Token.new(TokenType::LParen)
            i += 1
          elsif ch == ')'
            tokens << Token.new(TokenType::RParen)
            i += 1
          elsif ch == '['
            tokens << Token.new(TokenType::LBrack)
            i += 1
          elsif ch == ']'
            tokens << Token.new(TokenType::RBrack)
            i += 1
          elsif ch == '"'
            tokens << lex_string(input, pointerof(i))
          else
            start = i
            while i < input.size &&
                  !WHITESPACE.includes?(input[i]) &&
                  !NOT_IN_ATOM.includes?(input[i])
              i += 1
            end
            tokens << Token.new(TokenType::Atom, input[start...i])
          end
        end

        tokens
      end

      private def self.lex_string(input : String, i : Pointer(Int32)) : Token
        i.value += 1 # skip opening quote
        start = i.value
        end_index = input.size
        requires_alloc = false
        allocated = Array(UInt8).new

        while i.value < input.size
          ch = input[i.value]
          case ch
          when '"'
            end_index = i.value
            i.value += 1
            break
          when '\\'
            if i.value == input.size - 1
              end_index = i.value
              i.value += 1
              break
            end
            unless requires_alloc
              allocated = input[start...i.value].bytes.dup
              requires_alloc = true
            end
            allocated << input[i.value + 1].ord.to_u8
            i.value += 2
          else
            if requires_alloc
              allocated << ch.ord.to_u8
            end
            i.value += 1
          end
        end

        if requires_alloc
          bytes = Bytes.new(allocated.size) { |i| allocated[i] }
          Token.new(TokenType::String, String.new(bytes))
        else
          Token.new(TokenType::String, input[start...end_index])
        end
      end
    end

    # Parser: converts tokens into S-expression nodes
    class Parser
      @pos : Int32
      getter errors : Array(Error)

      def initialize(@tokens : Array(Token))
        @pos = 0
        @errors = Array(Error).new
      end

      def self.parse(tokens : Array(Token)) : {Nodes, Array(Error)}
        parser = new(tokens)
        sexprs = Array(Node).new
        while (sexpr = parser.sexpr)
          sexprs << sexpr
        end

        if parser.peek
          tok = parser.peek.not_nil!
          case tok.type
          when TokenType::RParen, TokenType::RBrack
            parser.errors << Error::ExtraClosingParen
          end
        end

        {Nodes.new(sexprs), parser.errors}
      end

      protected def peek : Token?
        @tokens[@pos]?
      end

      protected def next_token : Token?
        tok = @tokens[@pos]?
        @pos += 1 if @pos < @tokens.size
        tok
      end

      protected def sexpr : Node?
        case tok = peek
        when Token
          case tok.type
          when TokenType::LParen
            next_token
            list_node
          when TokenType::LBrack
            next_token
            group_node
          when TokenType::String
            next_token
            StringNode.new(tok.value)
          when TokenType::Atom
            next_token
            AtomNode.new(tok.value)
          when TokenType::Comment
            next_token
            CommentNode.new(tok.value)
          when TokenType::RParen, TokenType::RBrack
            nil
          end
        when nil
          nil
        end
      end

      protected def list_node : ListNode
        children = Array(Node).new
        while (child = sexpr)
          children << child
        end

        if (tok = peek) && tok.type == TokenType::RParen
          next_token
        else
          @errors << Error::MissingClosingParen
        end

        ListNode.new(Nodes.new(children))
      end

      protected def group_node : GroupNode
        children = Array(Node).new
        while (child = sexpr)
          children << child
        end

        if (tok = peek) && tok.type == TokenType::RBrack
          next_token
        else
          @errors << Error::MissingClosingParen
        end

        GroupNode.new(Nodes.new(children))
      end
    end

    # Parse exactly one S-expression from a string
    def self.from_slice(input : String) : Result(Node)
      tokens = Lexer.lex(input)
      sexprs, errors = Parser.parse(tokens)

      if sexprs.children.size > 1
        errors << Error::ExtraSexprs
      end

      if errors.empty?
        if sexprs.children.empty?
          Result(Node).new(errors: [Error::EmptyInput])
        else
          Result(Node).new(value: sexprs.children[0])
        end
      else
        Result(Node).new(errors: errors)
      end
    end

    # Parse multiple S-expressions from a string
    def self.from_slice_multi(input : String) : Result(Nodes)
      tokens = Lexer.lex(input)
      sexprs, errors = Parser.parse(tokens)

      if errors.empty?
        Result(Nodes).new(value: sexprs)
      else
        Result(Nodes).new(errors: errors)
      end
    end
  end
end
