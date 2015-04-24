require_relative '../cli/utilities'
Reek::CLI::Utilities.require_silently do
  require 'parser/current'
end
require_relative '../core/tree_dresser'
require_relative '../core/ast_node'

module Reek
  module Source
    #
    # A +Source+ object represents a chunk of Ruby source code.
    #
    class SourceCode
      attr_reader :description

      # Initializer.
      #
      # code        - ruby code as String
      # description - in case of STDIN this is "STDIN" otherwise it's a filepath as String
      # parser      - the parser to use for generating AST's out of the given source
      def initialize(code, description, parser = Parser::Ruby21)
        @source      = code
        @description = description
        @parser      = parser
      end

      def self.from(source)
        case source
        when File   then new(source.read, source.path)
        when IO     then new(source.readlines.join, 'STDIN')
        when String then new(source, 'string')
        end
      end

      def syntax_tree
        @syntax_tree ||=
          begin
            begin
              ast, comments = @parser.parse_with_comments(@source, @description)
            rescue Racc::ParseError, Parser::SyntaxError => error
              $stderr.puts "#{description}: #{error.class.name}: #{error}"
            end

            comment_map = Parser::Source::Comment.associate(ast, comments) if ast
            Core::TreeDresser.new.dress(ast, comment_map)
          end
      end
    end
  end
end
