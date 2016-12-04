module HumanAttributes
  class MethodBuilder
    include HumanAttributes::Config

    attr_reader :model_class

    def initialize(model_class)
      @model_class = model_class
    end

    def build(formatter)
      action = formatter_proc(formatter)
      model_class.send(:define_method, formatter.method_name) do
        action.call(send(formatter.attribute))
      end
    end

    private

    def formatter_proc(formatter)
      Proc.new do |value|
        value = formatter.default unless value
        formatter.apply(value)
      end
    end
  end
end
