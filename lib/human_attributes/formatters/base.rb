module HumanAttributes
  module Formatters
    class Base
      attr_reader :definition, :value

      def initialize(definition, value)
        @definition = definition
        @value = value
      end

      def apply
        raise HumanAttributes::Error::NotImplemented.new
      end
    end
  end
end
