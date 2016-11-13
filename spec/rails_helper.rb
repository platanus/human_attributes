ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../spec/dummy/config/environment", __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "pry"
require "spec_helper"
require "rspec/rails"
require "factory_girl_rails"

ActiveRecord::Migration.maintain_test_schema!

Dir[::Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/assets"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  FactoryGirl.definition_file_paths = ["#{::Rails.root}/spec/factories"]
  FactoryGirl.find_definitions

  config.include FactoryGirl::Syntax::Methods
  config.include ActionDispatch::TestProcess
  config.include TestHelpers
end
