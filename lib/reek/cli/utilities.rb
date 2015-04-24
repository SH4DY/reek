module Reek
  module CLI
    # CLI utilities
    module Utilities
      def self.require_silently
        old_verbose, $VERBOSE = $VERBOSE, nil
        yield if block_given?
        $VERBOSE = old_verbose
      end
    end
  end
end
