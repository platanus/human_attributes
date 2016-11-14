module HumanAttributes
  class AttributeDefinition
    attr_reader :attribute, :type, :options

    def initialize(attribute, type, options)
      @attribute = attribute.to_sym
      @type = type.to_sym
      @options = options
    end

    def method_name
      "human_#{attribute}"
    end
  end
end
