module HumanAttributes
  class MethodBuilder
    include HumanAttributes::Config

    attr_reader :model_class

    def initialize(model_class)
      @model_class = model_class
    end

    def build(formatter)
      model_class.send(:define_method, formatter.method_name) do
        value = send(formatter.attribute) || formatter.default
        formatter.apply(self, value)
      end
    end
  end
end
