module HumanAttributes
  module Formatters
    class Enumerize < Base
      def apply
        return unless value
        raise_error('NotEnumerizeAttribute') unless value.class.to_s == "Enumerize::Value"
        value.text
      end
    end
  end
end
