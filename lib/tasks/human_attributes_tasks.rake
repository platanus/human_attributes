require "factory_bot"

namespace :human_attrs do
  desc "Show generated human attributes for ActiveRecord models"
  task :show, [:model] => [:environment] do |_t, args|
    FactoryBot.reload
    model_name = args[:model].tableize.singularize
    model = args[:model].classify.constantize

    instance = begin
      FactoryBot.build(model_name)
    rescue
      nil
    end

    if instance
      instance.id = 1 if instance.respond_to?(:id)
      instance.created_at = DateTime.current if instance.respond_to?(:created_at)
      instance.updated_at = DateTime.current if instance.respond_to?(:updated_at)
    end

    result = model.humanizers.map do |m|
      value = begin
        instance.send(m)
      rescue
        nil
      end

      !!value ? "#{m} => #{value}" : m
    end

    puts result.join("\n")
  end
end
