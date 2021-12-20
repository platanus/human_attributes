module HumanAttributes
  class Engine < ::Rails::Engine
    isolate_namespace HumanAttributes

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_bot, dir: "spec/factories"
    end

    initializer "initialize" do
      require_relative "./config"
      require_relative "./errors"
      require_relative "./formatters_builder"
      require_relative "./formatters/base"
      require_relative "./formatters/numeric"
      require_relative "./formatters/date"
      require_relative "./formatters/datetime"
      require_relative "./formatters/boolean"
      require_relative "./formatters/enumerize"
      require_relative "./formatters/enum"
      require_relative "./formatters/custom"
      require_relative "./method_builder"
      require_relative "./extension"
    end
  end
end
