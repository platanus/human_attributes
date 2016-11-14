module HumanAttributes
  class Engine < ::Rails::Engine
    isolate_namespace HumanAttributes

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_girl, dir: "spec/factories"
    end

    initializer "initialize" do
      require_relative "./config"
      require_relative "./errors"
      require_relative "./attribute_definition"
      require_relative "./attributes_collection"
      require_relative "./method_builder"
      require_relative "./active_record_extension"
    end
  end
end
