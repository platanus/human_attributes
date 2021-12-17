module HumanAttributes
  module Formatters
    class Enum < Base
      def apply(_instance, value)
        return unless value

        is_enum_defined = _instance.class.defined_enums.has_key?(attribute.to_s)
        raise_error('NotEnumAttribute') unless is_enum_defined
        class_name = _instance.class.name.underscore
        attr_key = "activerecord.attributes.#{class_name}.#{attribute}.#{value}"
        enum_key = "enum.defaults.#{attribute}.#{value}"
        translate(attr_key, translate(enum_key, value))
      end

      def translate(key, default)
        I18n.t(key,  { default: default })
      end

      def enum_defined?(_instance)
        _instance.class.defined_enums.has_key?(attribute.to_s)
      end
    end
  end
end
