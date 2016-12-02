module HumanAttributes
  module Formatters
    class Base
      include HumanAttributes::Config

      attr_reader :definition, :value

      def initialize(definition, value)
        @definition = definition
        @value = value
      end

      def apply
        raise_error('NotImplemented')
      end
    end
  end
end
