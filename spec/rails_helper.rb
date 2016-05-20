# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'
require 'airborne'
require 'factory_girl_rails'
require 'spec_helper'
require 'database_cleaner'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
ActiveRecord::Migration.maintain_test_schema!


Airborne.configure do |config|
  config.rack_app = Rails.application
end

RSpec.configure do |config|

  config.use_transactional_fixtures = true
  #config.include Capybara::DSL,type: :request
  config.infer_spec_type_from_file_location!
  config.include RSpec::Rails::RequestExampleGroup, {:type => :request,
  :file_path => /spec\/requests/}

  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
   DatabaseCleaner.strategy = :truncation, {except: ['spatial_ref_sys']}
  end

  # config.before(:each) do
  #  DatabaseCleaner.strategy = :transaction
  # end

  # config.before(:each, :js => true) do
  #  DatabaseCleaner.strategy = :truncation, {except: ['spatial_ref_sys']}
  # end

  config.before(:each) do
   DatabaseCleaner.start
  end

  config.after(:each) do
   DatabaseCleaner.clean
  end

end
