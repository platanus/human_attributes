module HumanAttributes
  module Formatters
    class Boolean < Base
      def apply(value)
        key = !!value ? "positive" : "negative"
        I18n.t("boolean.#{key}")
      end
    end
  end
end
