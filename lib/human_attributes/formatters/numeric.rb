module HumanAttributes
  module Formatters
    class Numeric < Base
      include ActionView::Helpers::NumberHelper

      FORMATETERS = {
        currency: :number_to_currency,
        number: :number_to_human,
        size: :number_to_human_size,
        percentage: :number_to_percentage,
        phone: :number_to_phone,
        delimiter: :number_with_delimiter,
        precision: :number_with_precision
      }

      def apply
        send(FORMATETERS[definition.type], value, definition.options)
      end
    end
  end
end
