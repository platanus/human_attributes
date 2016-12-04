module HumanAttributes
  module Formatters
    class Custom < Base
      attr_reader :formatter

      def initialize(attribute, type, options)
        @formatter = options.delete(:formatter)
        raise_error('MissingFormatterOption') unless formatter.is_a?(Proc)
        super
      end

      def apply(instance, value)
        formatter.call(instance, value)
      end
    end
  end
end
