require "rake"
require "rspec/core/rake_task"

namespace :spec do
  namespace :zelig do
    RSpec::Core::RakeTask.new(:fixtures) do |t|
      t.rspec_opts = %w{--tag zelig:fixtures}
    end

    RSpec::Core::RakeTask.new(:middleware) do |t|
      t.rspec_opts = %w{--tag zelig:middleware}
    end
  end
end
