require 'rubygems'
require 'bundler/setup'

require 'combustion'

Combustion.initialize! :active_record, :action_controller, :action_view

require 'rspec/rails'

RSpec.configure do |config|
  config.use_transactional_fixtures = true
end
