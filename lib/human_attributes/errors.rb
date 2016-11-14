module HumanAttributes
  module Error
    class InvalidOptions < Exception
      def initialize
        super("humanize options needs to be a Hash")
      end
    end

    class InvalidType < Exception
      def initialize
        super("type needs to be one of: #{HumanAttributes::Config::TYPES.join(', ')}")
      end
    end

    class UniqueAttributeType < Exception
      def initialize
        super("type needs to be unique")
      end
    end

    class RequiredAttributeType < Exception
      def initialize
        super("type is required")
      end
    end

    class InvalidAttributeOptions < Exception
      def initialize
        super("options needs to be a Hash")
      end
    end
  end
end
