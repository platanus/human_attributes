module HumanAttributes
  module Config
    TYPES = [
      { name: :currency, category: :numeric, formatter: :number_to_currency },
      { name: :number, category: :numeric, formatter: :number_to_human },
      { name: :size, category: :numeric, formatter: :number_to_human_size },
      { name: :percentage, category: :numeric, formatter: :number_to_percentage },
      { name: :phone, category: :numeric, formatter: :number_to_phone },
      { name: :delimiter, category: :numeric, formatter: :number_with_delimiter },
      { name: :precision, category: :numeric, formatter: :number_with_precision },
      { name: :date, category: :date },
      { name: :boolean, category: :boolean },
      { name: :enumerize, category: :enumerize }
    ]

    def category_by_type(type)
      type_config(type)[:category]
    end

    def formatter_by_type(type)
      type_config(type)[:formatter]
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
