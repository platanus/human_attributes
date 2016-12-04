module HumanAttributes
  module Formatters
    class Numeric < Base
      include ActionView::Helpers::NumberHelper

      def apply(value)
        send(formatter_by_type(type), value, options)
      end
    end
  end
end
