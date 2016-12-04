module HumanAttributes
  module Formatters
    class Date < Base
      def apply(value)
        I18n.l(value, options)
      end
    end
  end
end
