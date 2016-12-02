module HumanAttributes
  class AttributesCollection
    include HumanAttributes::Config

    def initialize(attributes, options)
      @attributes = []
      raise_error('InvalidOptions') unless options.is_a?(Hash)
      type = get_type(options)
      opts = get_options(type, options)
      @attributes = attributes.map do |attribute|
        HumanAttributes::AttributeDefinition.new(attribute, type, opts)
      end.flatten
    end

    def get
      @attributes
    end

    private

    def get_type(options)
      size = options.keys.count
      raise_error('RequiredAttributeType') if size.zero?
      raise_error('UniqueAttributeType') if size > 1
      type = options.keys.first
      raise_error('InvalidType') unless known_type?(type)
      type
    end

    def get_options(type, options)
      opts = options[type]
      return {} if opts == true
      raise_error('InvalidAttributeOptions') unless opts.is_a?(Hash)
      opts
    end
  end
end
