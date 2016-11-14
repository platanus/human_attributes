module HumanAttributes
  class AttributesCollection
    def initialize(attributes, options)
      @attributes = []
      raise HumanAttributes::Error::InvalidOptions.new unless options.is_a?(Hash)
      type = get_type(options)
      opts = get_options(type, options)
      @attributes = attributes.map do |attribute|
        HumanAttributes::AttributeDefinition.new(attribute, type, opts)
      end
    end

    def get
      @attributes
    end

    private

    def get_type(options)
      size = options.keys.count
      raise HumanAttributes::Error::RequiredAttributeType.new if size.zero?
      raise HumanAttributes::Error::UniqueAttributeType.new if size > 1
      type = options.keys.first
      if !HumanAttributes::Config::TYPES.include?(type)
        raise HumanAttributes::Error::InvalidType.new
      end
      type
    end

    def get_options(type, options)
      opts = options[type]
      return {} if opts == true
      raise HumanAttributes::Error::InvalidAttributeOptions.new unless opts.is_a?(Hash)
      opts
    end
  end
end
