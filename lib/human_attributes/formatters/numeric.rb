module HumanAttributes
  module Formatters
    class Numeric < Base
      include ActionView::Helpers::NumberHelper

      def apply(_instance, value)
        send(formatter_by_type(type), value, options)
      end
    end
  end
end
