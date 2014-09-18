# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
require "factory_girl_rails"
require "database_cleaner"

RSpec.configure do |config|
  config.profile_examples = 2
  config.include FactoryGirl::Syntax::Methods
  
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end
    config.before(:each) do
    DatabaseCleaner.start
  end
    config.after(:each) do
    DatabaseCleaner.clean
  end
end
