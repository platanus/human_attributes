module HumanAttributes
  module Error
    class NotImplemented < Exception
      def initialize
        super("formatter not implemented")
      end
    end

    class InvalidOptions < Exception
      def initialize
        super("humanize options needs to be a Hash")
      end
    end

    class NotEnumerizeAttribute < Exception
      def initialize
        super("needs to be an Enumerize::Value object")
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
