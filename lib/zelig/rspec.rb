RSpec.configure do |config|
  config.filter_run_excluding :zelig => :fixtures
  config.include Zelig::SpecHelpers
end
