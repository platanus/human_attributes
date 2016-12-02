module HumanAttributes
  class MethodBuilder
    include HumanAttributes::Config

    attr_reader :model_class

    def initialize(model_class)
      @model_class = model_class
    end

    def build(definition)
      action = formatter_proc(definition)
      model_class.send(:define_method, definition.method_name) do
        action.call(send(definition.attribute))
      end
      nil
    end

    private

    def formatter_class(type)
      return HumanAttributes::Formatters::Numeric if numeric_type?(type)
      return HumanAttributes::Formatters::Date if date_type?(type)
    end

    def formatter_proc(definition)
      Proc.new do |value|
        value = definition.default unless value
        formatter_class(definition.type).new(definition, value).apply
      end
    end
  end
end
