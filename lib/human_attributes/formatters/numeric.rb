module HumanAttributes
  module Formatters
    class Numeric < Base
      include ActionView::Helpers::NumberHelper

      def apply
        send(get_formatter(definition), value, definition.options)
      end

      # rubocop:disable Metrics/CyclomaticComplexity
      def get_formatter(definition)
        case definition.type
        when :currency then :number_to_currency
        when :number then :number_to_human
        when :size then :number_to_human_size
        when :percentage then :number_to_percentage
        when :phone then :number_to_phone
        when :delimiter then :number_with_delimiter
        when :precision then :number_with_precision
        end
      end
    end
  end
end
