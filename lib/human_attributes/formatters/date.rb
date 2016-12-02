module HumanAttributes
  module Formatters
    class Date < Base
      def apply
        I18n.l(value, definition.options)
      end
    end
  end
end
