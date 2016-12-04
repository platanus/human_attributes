module HumanAttributes
  module Config
    TYPES = [
      {
        name: :currency,
        category: :numeric,
        formatter: :number_to_currency,
        suffix: :to_currency
      },
      {
        name: :number,
        category: :numeric,
        formatter: :number_to_human,
        suffix: :to_human
      },
      {
        name: :size,
        category: :numeric,
        formatter: :number_to_human_size,
        suffix: :to_human_size
      },
      {
        name: :percentage,
        category: :numeric,
        formatter: :number_to_percentage,
        suffix: :to_percentage
      },
      {
        name: :phone,
        category: :numeric,
        formatter: :number_to_phone,
        suffix: :to_phone
      },
      {
        name: :delimiter,
        category: :numeric,
        formatter: :number_with_delimiter,
        suffix: :with_delimiter
      },
      {
        name: :precision,
        category: :numeric,
        formatter: :number_with_precision,
        suffix: :with_precision
      },
      {
        name: :date,
        category: :date,
        suffix: :to_human_date
      },
      {
        name: :boolean,
        category: :boolean,
        suffix: :to_human_boolean
      },
      {
        name: :enumerize,
        category: :enumerize,
        suffix: :to_human_enum
      }
    ]

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
