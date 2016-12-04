module HumanAttributes
  module ActiveRecordExtension
    extend ActiveSupport::Concern

    class_methods do
      def humanize(*attrs, options)
        formatters = HumanAttributes::FormattersCollection.new(attrs, options).get
        @builder ||= HumanAttributes::MethodBuilder.new(self)
        formatters.each { |formatter| @builder.build(formatter) }
      end
    end
  end
end

ActiveRecord::Base.send(:include, HumanAttributes::ActiveRecordExtension)
