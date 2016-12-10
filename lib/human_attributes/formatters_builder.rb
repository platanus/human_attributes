module HumanAttributes
  class FormattersBuilder
    include HumanAttributes::Config

    def initialize(attributes, config)
      raise_error('InvalidHumanizeConfig') unless config.is_a?(Hash)
      @attributes = attributes
      @config = config
    end

    def build
      formatters = []

      get_types(@config).each do |type|
        raise_error('InvalidType') unless known_type?(type)
        options = get_options(@config[type])
        formatters << @attributes.map do |attribute|
          formatter_class(type).new(attribute, type, options)
        end
      end

      formatters.flatten
    end

    private

    def formatter_class(type)
      category = category_by_type(type)
      "HumanAttributes::Formatters::#{category.to_s.classify}".constantize
    end

    def get_types(options)
      size = options.keys.count
      raise_error('RequiredAttributeType') if size.zero?
      options.keys
    end

    def get_options(options)
      return {} if options == true
      raise_error('InvalidAttributeOptions') unless options.is_a?(Hash)
      options
    end
  end
end
