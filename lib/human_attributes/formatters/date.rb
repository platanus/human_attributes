module HumanAttributes
  module Formatters
    class Date < Base
      def apply(_instance, value)
        I18n.l(value.to_date, **options)
      rescue
        nil
      end
    end
  end
end
