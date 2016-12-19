module HumanAttributes
  module Formatters
    class Base
      include HumanAttributes::Config

      attr_reader :attribute, :type, :options, :default, :suffix

      def initialize(attribute, type, options)
        @attribute = attribute.to_sym
        @type = type.to_sym
        @default = options[:default]
        @suffix = options[:suffix]
        @options = options
      end

      def method_name
        return "human_#{attribute}" if suffix.blank?
        return "#{attribute}_#{suffix_by_type(type)}" if suffix == true
        "#{attribute}_#{suffix}"
      end

      def apply(_instance, _value)
        raise_error('NotImplemented')
      end
    end
  end
end
