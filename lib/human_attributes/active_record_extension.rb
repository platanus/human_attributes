module HumanAttributes
  module ActiveRecordExtension
    extend ActiveSupport::Concern

    class_methods do
      def humanize(*attrs, options)
        formatters = HumanAttributes::FormattersBuilder.new(attrs, options).get
        @builder ||= HumanAttributes::MethodBuilder.new(self)
        formatters.each { |formatter| @builder.build(formatter) }
      end

      def humanize_attributes
        columns.each do |col|
          next if col.name.ends_with?("_id")
          humanize_from_type(col)
        end
      end

      private

      def humanize_from_type(col)
        if col.name == "id"
          humanize(:id, custom: { formatter: ->(_o, value) { "#{model_name.human}: ##{value}" } })
        elsif [:date, :datetime].include?(col.type)
          humanize_date(col.name)
        elsif [:decimal, :float, :integer].include?(col.type)
          humanize(col.name, number: true)
        elsif col.type == :boolean
          humanize(col.name, boolean: true)
        end
      end

      def humanize_date(attr_name)
        humanize(attr_name, date: true)
        humanize(attr_name, date: { format: :short, suffix: "to_short_date" })
      end
    end
  end
end

ActiveRecord::Base.send(:include, HumanAttributes::ActiveRecordExtension)
