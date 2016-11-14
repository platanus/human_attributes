module HumanAttributes
  class MethodBuilder
    attr_reader :model_class

    def initialize(model_class)
      @model_class = model_class
    end

    def build(definition)
      model_class.send(:define_method, definition.method_name) do
        value = send(definition.attribute)
        number_to_currency(value, definition.options)
      end
      nil
    end
  end
end
