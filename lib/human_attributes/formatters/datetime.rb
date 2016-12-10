module HumanAttributes
  module Formatters
    class Datetime < Base
      def apply(_instance, value)
        I18n.l(value.to_datetime, options)
      rescue
        nil
      end
    end
  end
end
