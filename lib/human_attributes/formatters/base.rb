module HumanAttributes
  module Formatters
    class Base
      include HumanAttributes::Config

      attr_reader :attribute, :type, :options, :default

      def initialize(attribute, type, options)
        @attribute = attribute.to_sym
        @type = type.to_sym
        @default = options.delete(:default)
        @options = options
      end

      def method_name
        "human_#{attribute}"
      end

      def apply(_value)
        raise_error('NotImplemented')
      end
    end
  end
end
