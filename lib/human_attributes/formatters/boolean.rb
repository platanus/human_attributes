module HumanAttributes
  module Formatters
    class Boolean < Base
      def apply(_instance, value)
        key = !!value ? "positive" : "negative"
        I18n.t("boolean.#{key}")
      end
    end
  end
end
