module TreeSitterManager
  # Lua pattern parser and regex converter.
  # Parses Lua patterns into structured representation and converts to regex.
  module LuaPattern
    # Error types for parsing failures
    class Error < Exception
      enum Kind
        UnfinishedEscape
        UnclosedSet
        MissingCharsForBalanced
        MissingSetForFrontier
        UnexpectedToken
        InvalidCaptureRef
        OpenEndedRange
      end

      getter kind : Kind
      getter detail : String?

      def initialize(@kind : Kind, @detail : String? = nil)
        super(message)
      end

      def message : String
        case @kind
        in .unfinished_escape?          then "unfinished escape"
        in .unclosed_set?               then "missing `]` to close set"
        in .missing_chars_for_balanced? then "missing characters for `%b`"
        in .missing_set_for_frontier?   then "missing `[` after `%f`"
        in .unexpected_token?           then "unexpected token: `#{@detail}`"
        in .invalid_capture_ref?        then "unknown capture ref: `#{@detail}`"
        in .open_ended_range?           then "open-ended range at: `#{@detail}`"
        end
      end
    end

    # Regex conversion error
    class ToRegexError < Exception
      enum Kind
        BalancedUsed
        CaptureRefUsed
        FrontierUsed
      end

      getter kind : Kind

      def initialize(@kind : Kind)
        super(case @kind
        in .balanced_used?    then "balanced pattern (%b) cannot be regex"
        in .capture_ref_used? then "capture backreference not supported"
        in .frontier_used?    then "frontier pattern requires lookaround"
        end)
      end
    end

    enum Class
      Letters; Controls; Digits; Printable; Lowercase; Punctuations
      Spaces; Uppercase; Alphanumerics; Hexadecimals; ZeroByte
      NotLetters; NotControls; NotDigits; NotPrintable; NotLowercase
      NotPunctuations; NotSpaces; NotUppercase; NotAlphanumerics
      NotHexadecimals; NotZeroByte
    end

    enum Quantifier
      ZeroOrMore; OneOrMore; ZeroOrMoreLazy; ZeroOrOne
    end

    # --- Pattern Objects ---

    abstract class PatternObject
      abstract def to_regex(allow_capture_refs : Bool, allow_lookaround : Bool) : String
    end

    class PatternAny < PatternObject
      def to_regex(allow_capture_refs : Bool, allow_lookaround : Bool) : String
        "[\\s\\S]"
      end
    end

    class PatternStart < PatternObject
      def to_regex(allow_capture_refs : Bool, allow_lookaround : Bool) : String
        "^"
      end
    end

    class PatternEnd < PatternObject
      def to_regex(allow_capture_refs : Bool, allow_lookaround : Bool) : String
        "$"
      end
    end

    class PatternString < PatternObject
      getter value : String

      def initialize(@value : String)
      end

      def to_regex(allow_capture_refs : Bool, allow_lookaround : Bool) : String
        LuaPattern.escape_regex(@value)
      end
    end

    class PatternQuantifier < PatternObject
      getter quantifier : Quantifier
      getter child : PatternObject

      def initialize(@quantifier : Quantifier, @child : PatternObject)
      end

      def to_regex(allow_capture_refs : Bool, allow_lookaround : Bool) : String
        suffix = case @quantifier
                 in .zero_or_more?      then "*"
                 in .one_or_more?       then "+"
                 in .zero_or_more_lazy? then "*?"
                 in .zero_or_one?       then "?"
                 end
        @child.to_regex(allow_capture_refs, allow_lookaround) + suffix
      end
    end

    class PatternEscaped < PatternObject
      getter char : Char

      def initialize(@char : Char)
      end

      def to_regex(allow_capture_refs : Bool, allow_lookaround : Bool) : String
        LuaPattern.escape_regex(@char.to_s)
      end
    end

    class PatternClass < PatternObject
      getter cls : Class

      def initialize(@cls : Class)
      end

      def to_regex(allow_capture_refs : Bool, allow_lookaround : Bool) : String
        LuaPattern.class_to_regex(@cls)
      end
    end

    class PatternCaptureRef < PatternObject
      getter id : UInt8

      def initialize(@id : UInt8)
      end

      def to_regex(allow_capture_refs : Bool, allow_lookaround : Bool) : String
        raise ToRegexError.new(ToRegexError::Kind::CaptureRefUsed) unless allow_capture_refs
        "\\#{@id}"
      end
    end

    class PatternBalanced < PatternObject
      getter open : Char
      getter close : Char

      def initialize(@open : Char, @close : Char)
      end

      def to_regex(allow_capture_refs : Bool, allow_lookaround : Bool) : String
        raise ToRegexError.new(ToRegexError::Kind::BalancedUsed)
      end
    end

    class PatternFrontier < PatternObject
      getter inverted : Bool
      getter set_children : Array(SetPatternObject)

      def initialize(@inverted : Bool, @set_children : Array(SetPatternObject))
      end

      def to_regex(allow_capture_refs : Bool, allow_lookaround : Bool) : String
        raise ToRegexError.new(ToRegexError::Kind::FrontierUsed) unless allow_lookaround
        set_str = set_children.map(&.to_regex).join
        "(?<#{@inverted ? "=" : "!"}#{set_str})(?#{@inverted ? "!" : "="}#{set_str})"
      end
    end

    class PatternCapture < PatternObject
      getter id : UInt8
      getter children : Array(PatternObject)

      def initialize(@id : UInt8, @children : Array(PatternObject))
      end

      def to_regex(allow_capture_refs : Bool, allow_lookaround : Bool) : String
        "(#{@children.map { |c| c.to_regex(allow_capture_refs, allow_lookaround) }.join})"
      end
    end

    class PatternSet < PatternObject
      getter inverted : Bool
      getter set_children : Array(SetPatternObject)

      def initialize(@inverted : Bool, @set_children : Array(SetPatternObject))
      end

      def to_regex(allow_capture_refs : Bool, allow_lookaround : Bool) : String
        inner = @set_children.map(&.to_regex).join
        "[#{@inverted ? "^" : ""}#{inner}]"
      end
    end

    # --- Set Pattern Objects ---

    abstract class SetPatternObject
      abstract def to_regex : String
    end

    class SetChar < SetPatternObject
      getter char : Char

      def initialize(@char : Char)
      end

      def to_regex : String
        LuaPattern.escape_regex(@char.to_s)
      end
    end

    class SetEscaped < SetPatternObject
      getter char : Char

      def initialize(@char : Char)
      end

      def to_regex : String
        LuaPattern.escape_regex(@char.to_s)
      end
    end

    class SetRange < SetPatternObject
      getter start : Char
      getter end_ : Char

      def initialize(@start : Char, @end_ : Char)
      end

      def to_regex : String
        "#{LuaPattern.escape_regex(@start.to_s)}-#{LuaPattern.escape_regex(@end_.to_s)}"
      end
    end

    class SetClass < SetPatternObject
      getter cls : Class

      def initialize(@cls : Class)
      end

      def to_regex : String
        LuaPattern.class_to_regex(@cls)
      end
    end

    # --- Internal Token ---

    private enum TokenType
      Start; End; Any; ZeroOrMore; OneOrMore; ZeroOrMoreLazy; ZeroOrOne
      Inverse; LParen; RParen; LBrack; RBrack
      Char; Escaped; Class; CaptureRef; Balanced; Frontier; Eof
    end

    private record LexToken, type : TokenType, char_val : Char = '\0',
      cls_val : Class = Class::Letters, capture_id : UInt8 = 0,
      bal_open : Char = '\0', bal_close : Char = '\0'

    # --- Lexer ---

    private class LuaLexer
      @input : String
      @curr : Int32
      @next : Int32

      def initialize(@input : String)
        @curr = -1
        @next = -1
        advance
        advance
      end

      def lex : Array(LexToken)
        tokens = Array(LexToken).new

        if curr_char == '^'
          tokens << LexToken.new(TokenType::Start)
          advance
        end

        while (curr = curr_char)
          case curr
          when '(' then tokens << LexToken.new(TokenType::LParen); advance
          when ')' then tokens << LexToken.new(TokenType::RParen); advance
          when '.'
            tokens << LexToken.new(TokenType::Any); advance
            read_quantity(tokens)
          when '$'
            if next_char.nil?
              tokens << LexToken.new(TokenType::End); advance
            else
              tokens << LexToken.new(TokenType::Char, char_val: '$'); advance
              read_quantity(tokens)
            end
          when '%'
            advance
            c = curr_char
            raise Error.new(Error::Kind::UnfinishedEscape) unless c
            case c
            when 'b'
              advance; o = curr_char
              raise Error.new(Error::Kind::MissingCharsForBalanced) unless o
              advance; cl = curr_char
              raise Error.new(Error::Kind::MissingCharsForBalanced) unless cl
              advance
              tokens << LexToken.new(TokenType::Balanced, bal_open: o, bal_close: cl)
            when 'f'
              advance
              raise Error.new(Error::Kind::MissingSetForFrontier) unless curr_char == '['
              tokens << LexToken.new(TokenType::Frontier)
              read_set(tokens)
            when '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'
              tokens << LexToken.new(TokenType::CaptureRef, capture_id: (c - '0').to_u8)
              advance
            else
              read_escape(tokens)
              read_quantity(tokens)
            end
          when '['
            read_set(tokens)
            read_quantity(tokens)
          else
            tokens << LexToken.new(TokenType::Char, char_val: curr); advance
            read_quantity(tokens)
          end
        end

        tokens
      end

      private def advance
        @curr = @next
        @next += 1
      end

      private def curr_char : Char?
        return nil if @curr < 0 || @curr >= @input.size
        @input[@curr]
      end

      private def next_char : Char?
        return nil if @next < 0 || @next >= @input.size
        @input[@next]
      end

      private def read_quantity(tokens)
        case curr_char
        when '+' then tokens << LexToken.new(TokenType::OneOrMore); advance
        when '-' then tokens << LexToken.new(TokenType::ZeroOrMoreLazy); advance
        when '*' then tokens << LexToken.new(TokenType::ZeroOrMore); advance
        when '?' then tokens << LexToken.new(TokenType::ZeroOrOne); advance
        end
      end

      private def read_escape(tokens)
        c = curr_char
        raise Error.new(Error::Kind::UnfinishedEscape) unless c
        tokens << if cls = class_from_char(c)
          LexToken.new(TokenType::Class, cls_val: cls)
        else
          LexToken.new(TokenType::Escaped, char_val: c)
        end
        advance
      end

      private def read_set(tokens)
        tokens << LexToken.new(TokenType::LBrack); advance
        if curr_char == '^'
          tokens << LexToken.new(TokenType::Inverse); advance
        end
        loop do
          c = curr_char
          raise Error.new(Error::Kind::UnclosedSet) unless c
          if c == '%'
            advance; read_escape(tokens)
          else
            tokens << LexToken.new(TokenType::Char, char_val: c); advance
          end
          break if curr_char == ']'
        end
        tokens << LexToken.new(TokenType::RBrack); advance
      end

      private def class_from_char(c : Char) : Class?
        case c
        when 'a' then Class::Letters
        when 'c' then Class::Controls
        when 'd' then Class::Digits
        when 'g' then Class::Printable
        when 'l' then Class::Lowercase
        when 'p' then Class::Punctuations
        when 's' then Class::Spaces
        when 'u' then Class::Uppercase
        when 'w' then Class::Alphanumerics
        when 'x' then Class::Hexadecimals
        when 'z' then Class::ZeroByte
        when 'A' then Class::NotLetters
        when 'C' then Class::NotControls
        when 'D' then Class::NotDigits
        when 'G' then Class::NotPrintable
        when 'L' then Class::NotLowercase
        when 'P' then Class::NotPunctuations
        when 'S' then Class::NotSpaces
        when 'U' then Class::NotUppercase
        when 'W' then Class::NotAlphanumerics
        when 'X' then Class::NotHexadecimals
        when 'Z' then Class::NotZeroByte
        end
      end
    end

    # --- Parser ---

    private class LuaParser
      @tokens : Array(LexToken)
      @pos : Int32
      @capture_id : UInt8

      def initialize(@tokens : Array(LexToken))
        @pos = 0
        @capture_id = 1
      end

      def parse : Array(PatternObject)
        objects = Array(PatternObject).new
        while (tok = peek)
          objects << parse_object(tok)
        end
        objects
      end

      private def peek : LexToken?
        @tokens[@pos]?
      end

      private def advance
        @pos += 1
      end

      private def next_peek : LexToken?
        @tokens[@pos + 1]?
      end

      private def parse_object(tok : LexToken) : PatternObject
        case tok.type
        when .start? then advance; PatternStart.new
        when .end?   then advance; PatternEnd.new
        when .any?   then advance; with_quantifier(PatternAny.new)
        when .escaped?
          advance; with_quantifier(PatternEscaped.new(tok.char_val))
        when .class?
          advance; with_quantifier(PatternClass.new(tok.cls_val))
        when .capture_ref?
          raise Error.new(Error::Kind::InvalidCaptureRef, tok.capture_id.to_s) if tok.capture_id > @capture_id
          advance; PatternCaptureRef.new(tok.capture_id)
        when .balanced?
          advance; PatternBalanced.new(tok.bal_open, tok.bal_close)
        when .frontier?
          advance; set = parse_set
          PatternFrontier.new(set[0], set[1])
        when .l_paren?
          parse_capture
        when .l_brack?
          set = parse_set
          with_quantifier(PatternSet.new(set[0], set[1]))
        when .char?
          parse_string
        else
          raise Error.new(Error::Kind::UnexpectedToken, tok.type.to_s)
        end
      end

      private def with_quantifier(child : PatternObject) : PatternObject
        if (tok = peek) && (q = quantifier_from_token(tok.type))
          advance
          PatternQuantifier.new(q, child)
        else
          child
        end
      end

      private def quantifier_from_token(type : TokenType) : Quantifier?
        case type
        when .zero_or_more?      then Quantifier::ZeroOrMore
        when .one_or_more?       then Quantifier::OneOrMore
        when .zero_or_more_lazy? then Quantifier::ZeroOrMoreLazy
        when .zero_or_one?       then Quantifier::ZeroOrOne
        else                          nil
        end
      end

      private def parse_string : PatternObject
        string = String.build do |io|
          while (tok = peek) && tok.type.char?
            io << tok.char_val
            advance
            if (nt = peek) && quantifier_from_token(nt.type)
              break
            end
          end
        end
        with_quantifier(PatternString.new(string))
      end

      private def parse_set : {Bool, Array(SetPatternObject)}
        advance # LBrack
        children = Array(SetPatternObject).new
        inverted = false

        if (tok = peek) && tok.type.inverse?
          inverted = true
          advance
        end

        while (tok = peek) && tok.type != TokenType::RBrack
          case tok.type
          when .class?
            children << SetClass.new(tok.cls_val); advance
          when .char?
            advance
            if (nt = peek) && nt.type.char? && (nnt = next_peek)
              if nt.char_val == '-' && !nnt.type.r_brack?
                @pos += 1
                end_tok = peek
                raise Error.new(Error::Kind::OpenEndedRange, end_tok.try(&.type.to_s)) unless end_tok
                if end_tok.type.char?
                  children << SetRange.new(tok.char_val, end_tok.char_val); advance
                elsif end_tok.type.escaped?
                  children << SetRange.new(tok.char_val, end_tok.char_val); advance
                else
                  raise Error.new(Error::Kind::OpenEndedRange, end_tok.type.to_s)
                end
              else
                children << SetChar.new(tok.char_val)
              end
            else
              children << SetChar.new(tok.char_val)
            end
          when .escaped?
            children << SetEscaped.new(tok.char_val); advance
          else
            raise Error.new(Error::Kind::UnexpectedToken, tok.type.to_s)
          end
        end

        advance # RBrack
        {inverted, children}
      end

      private def parse_capture : PatternCapture
        id = @capture_id
        @capture_id += 1
        advance # LParen

        children = Array(PatternObject).new
        while (tok = peek) && tok.type != TokenType::RParen
          children << parse_object(tok)
        end

        raise Error.new(Error::Kind::UnclosedSet) unless peek.try(&.type.r_paren?)
        advance # RParen
        PatternCapture.new(id, children)
      end
    end

    # --- Public API ---

    def self.parse(pattern : String) : Array(PatternObject)
      lexer = LuaLexer.new(pattern)
      tokens = lexer.lex
      parser = LuaParser.new(tokens)
      parser.parse
    end

    def self.to_regex(pattern : Array(PatternObject), allow_capture_refs : Bool, allow_lookaround : Bool) : String
      pattern.map { |obj| obj.to_regex(allow_capture_refs, allow_lookaround) }.join
    end

    def self.class_to_regex(cls : Class) : String
      case cls
      in .letters?           then "[a-zA-Z]"
      in .controls?          then "[\\0-\\31]"
      in .digits?            then "[0-9]"
      in .printable?         then "[\\33-\\126]"
      in .lowercase?         then "[a-z]"
      in .punctuations?      then "[!\"\\#$%&'()*+,\\-./:;<=>?@\\[\\\\\\]^_`{|}\u{7e}]"
      in .spaces?            then "[ \\t\\n\\v\\f\\r]"
      in .uppercase?         then "[A-Z]"
      in .alphanumerics?     then "[a-zA-Z0-9]"
      in .hexadecimals?      then "[0-9a-fA-F]"
      in .zero_byte?         then "\\0"
      in .not_letters?       then "[^a-zA-Z]"
      in .not_controls?      then "[^\\0-\\31]"
      in .not_digits?        then "[^0-9]"
      in .not_printable?     then "[^\\33-\\126]"
      in .not_lowercase?     then "[^a-z]"
      in .not_punctuations?  then "[^!\"\\#$%&'()*+,\\-./:;<=>?@\\[\\\\\\]^_`{|}\u{7e}]"
      in .not_spaces?        then "[^ \\t\\n\\v\\f\\r]"
      in .not_uppercase?     then "[^A-Z]"
      in .not_alphanumerics? then "[^a-zA-Z0-9]"
      in .not_hexadecimals?  then "[^0-9a-fA-F]"
      in .not_zero_byte?     then "[^\\0]"
      end
    end

    SPECIAL_REGEX_CHARS = "\\.()[]{}|*+?^$/"

    def self.escape_regex(str : String) : String
      str.chars.map { |c| SPECIAL_REGEX_CHARS.includes?(c) ? "\\#{c}" : c.to_s }.join
    end
  end
end
