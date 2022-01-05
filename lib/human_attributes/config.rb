module HumanAttributes
  module Config
    def self.build_type(name, category, suffix, formatter = nil)
      config_type = {
        name: name,
        category: category,
        suffix: suffix
      }
      if formatter
        config_type[:formatter] = formatter
      end
      config_type
    end

    TYPES = [
      [:currency, :numeric, :to_currency, :number_to_currency],
      [:number, :numeric, :to_human, :number_to_human],
      [:size, :numeric, :to_human_size, :number_to_human_size],
      [:percentage, :numeric, :to_percentage, :number_to_percentage],
      [:phone, :numeric, :to_phone, :number_to_phone],
      [:delimiter, :numeric, :with_delimiter, :number_with_delimiter],
      [:precision, :numeric, :with_precision, :number_with_precision],
      [:date, :date, :to_human_date],
      [:datetime, :datetime, :to_human_datetime],
      [:boolean, :boolean, :to_human_boolean],
      [:enumerize, :enumerize, :to_human_enum],
      [:enum, :enum, :to_human_enum],
      [:custom, :custom, :to_custom_value]
    ].map { |config_type| build_type(*config_type) }

    OPTIONS = {
      boolean: [
        { boolean: true }
      ],
      date: [
        { date: true },
        { date: { format: :short, suffix: "to_short_date" } },
        { date: { format: :short, suffix: "to_long_date" } },
        { datetime: true },
        { datetime: { format: :short, suffix: "to_short_datetime" } },
        { datetime: { format: :short, suffix: "to_long_datetime" } }
      ],
      datetime: [
        { datetime: true },
        { datetime: { format: :short, suffix: "to_short_datetime" } },
        { datetime: { format: :short, suffix: "to_long_datetime" } }
      ],
      decimal: [{ delimiter: true }],
      enum: [{ enum: true }],
      float: [{ delimiter: true }],
      id: [{ custom: { formatter: ->(_o, value) { "#{_o.model_name.human}: ##{value}" } } }],
      integer: [{ delimiter: true }]
    }

    def category_by_type(type)
      type_config(type)[:category]
    end

    def formatter_by_type(type)
      type_config(type)[:formatter]
    end

    def suffix_by_type(type)
      type_config(type)[:suffix]
    end

    def known_type?(type)
      !!type_config(type)
    end

    def type_config(type)
      TYPES.select { |t| t[:name] == type }.first
    end

    def raise_error(error_class)
      raise "HumanAttributes::Error::#{error_class}".constantize.new
    end
  end
end
