module HumanAttributes
  module ActiveRecordExtension
    extend ActiveSupport::Concern

    class_methods do
      def humanize(*attrs, options)
        definitions = HumanAttributes::AttributesCollection.new(attrs, options).get
        @builder ||= HumanAttributes::MethodBuilder.new(self)
        definitions.each { |definition| @builder.build(definition) }
      end
    end
  end
end

ActiveRecord::Base.send(:include, HumanAttributes::ActiveRecordExtension)
