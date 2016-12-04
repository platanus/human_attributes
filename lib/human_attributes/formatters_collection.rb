module HumanAttributes
  class FormattersCollection
    include HumanAttributes::Config

    def initialize(attributes, options)
      raise_error('InvalidOptions') unless options.is_a?(Hash)
      @attributes = attributes
      @type = get_type(options)
      @options = get_options(@type, options)
    end

    def get
      @attributes.map do |attribute|
        formatter_class(@type).new(attribute, @type, @options)
      end.flatten
    end

    private

    def formatter_class(type)
      category = category_by_type(type)
      "HumanAttributes::Formatters::#{category.to_s.classify}".constantize
    end

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
