require_relative '../cli/utilities'
Reek::CLI::Utilities.require_silently do
  require 'unparser'
end

module Reek
  module Sexp
    #
    # Formats snippets of syntax tree back into Ruby source code.
    #
    class SexpFormatter
      # Formats the given sexp.
      #
      # sexp - S-expression of type AST::Node
      #
      # Returns a formatted string representation.
      def self.format(sexp)
        return sexp.to_s unless sexp.is_a? AST::Node
        lines = Unparser.unparse(sexp).split "\n"
        if lines.length > 1
          "#{lines.first} ... #{lines.last}"
        else
          lines.first
        end
      end
    end
  end
end
