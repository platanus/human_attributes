module HumanAttributes
  module Config
    NUMBER_TYPES = %i{currency number size percentage phone delimiter precision}
    TYPES = NUMBER_TYPES + [:date]

    def self.numeric_type?(type)
      NUMBER_TYPES.include?(type)
    end

    def self.known_type?(type)
      TYPES.include?(type)
    end

    def self.date_type?(type)
      type == :date
    end
  end
end
