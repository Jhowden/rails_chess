# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
require "factory_girl_rails"

RSpec.configure do |config|
  config.profile_examples = 2
  config.include FactoryGirl::Syntax::Methods
end
