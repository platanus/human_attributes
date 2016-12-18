module HumanAttributes
  module Error
    class NotImplemented < RuntimeError
      def initialize
        super("formatter not implemented")
      end
    end

    class InvalidHumanizeConfig < RuntimeError
      def initialize
        super("humanize options needs to be a Hash")
      end
    end

    class NotEnumerizeAttribute < RuntimeError
      def initialize
        super("needs to be an Enumerize::Value object")
      end
    end

    class MissingFormatterOption < RuntimeError
      def initialize
        super("custom type needs formatter option with a proc")
      end
    end

    class InvalidType < RuntimeError
      def initialize
        types = HumanAttributes::Config::TYPES.map { |t| t[:name] }
        super("type needs to be one of: #{types.join(', ')}")
      end
    end

    class RequiredAttributeType < RuntimeError
      def initialize
        super("type is required")
      end
    end

    class InvalidAttributeOptions < RuntimeError
      def initialize
        super("options needs to be a Hash")
      end
    end
  end
end
