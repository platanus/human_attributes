module HumanAttributes
  module Formatters
    class Enumerize < Base
      def apply(_instance, value)
        return unless value
        raise_error('NotEnumerizeAttribute') unless value.class.to_s == "Enumerize::Value"
        value.text
      end
    end
  end
end
