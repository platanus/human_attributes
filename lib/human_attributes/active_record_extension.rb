module HumanAttributes
  module ActiveRecordExtension
    extend ActiveSupport::Concern

    class_methods do
      def humanize(*attrs, options)
        formatters = HumanAttributes::FormattersBuilder.new(attrs, options).build
        @builder ||= HumanAttributes::MethodBuilder.new(self)
        @humanizers ||= []
        formatters.each { |formatter| @humanizers << @builder.build(formatter) }
      end

      def humanize_attributes(options = {})
        included_attrs = options.fetch(:only, nil)
        excluded_attrs = options.fetch(:except, nil)
        columns.each do |col|
          next if col.name.ends_with?("_id")
          next if included_attrs && !included_attrs.include?(col.name.to_sym)
          next if excluded_attrs && excluded_attrs.include?(col.name.to_sym)
          humanize_from_type(col)
        end
      end

      def humanizers
        return [] unless @humanizers
        @humanizers.uniq!
        @humanizers.reject! { |method| !method_defined?(method) }
        @humanizers
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
