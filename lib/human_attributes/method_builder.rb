module HumanAttributes
  class MethodBuilder
    include ActionView::Helpers::NumberHelper

    attr_reader :model_class

    def initialize(model_class)
      @model_class = model_class
    end

    def build(definition)
      action = Proc.new { |value| send(get_formatter(definition), value, definition.options) }
      model_class.send(:define_method, definition.method_name) do
        action.call(send(definition.attribute))
      end
      nil
    end

    private

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
