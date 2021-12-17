module HumanAttributes
  module Extension
    extend ActiveSupport::Concern

    class_methods do
      def humanize(*attrs, options)
        formatters = HumanAttributes::FormattersBuilder.new(attrs, options).build
        @builder ||= HumanAttributes::MethodBuilder.new(self)
        @humanizers ||= []
        formatters.each do |formatter|
          @humanizers << @builder.build(formatter)
        end
      end

      def humanize_attributes(options = {})
        included_attrs = options.fetch(:only, nil)
        excluded_attrs = options.fetch(:except, nil)
        columns.each do |col|
          next if col.name.ends_with?("_id")
          next if included_attrs && !included_attrs.include?(col.name.to_sym)
          next if excluded_attrs&.include?(col.name.to_sym)

          humanize_from_type(col)
        end
      end

      def humanizers
        return [] unless @humanizers

        @humanizers.uniq!
        @humanizers.select! { |method| method_defined?(method) }
        @humanizers
      end

      private

      def humanize_from_type(col)
        if HumanAttributes::Config::OPTIONS.has_key? humanizer_type(col)
          HumanAttributes::Config::OPTIONS[humanizer_type(col)].each do |options|
            humanize(col.name, options)
          end
        end
      end

      def humanizer_type(col)
        type = col.type
        if col.name == 'id'
          type = 'id'
        elsif defined_enums.has_key?(col.name)
          type = 'enum'
        end
        type.to_sym
      end
    end
  end
end

ActiveRecord::Base.include(HumanAttributes::Extension)

begin
  Draper::Decorator.include(HumanAttributes::Extension)
rescue NameError
  nil
end
