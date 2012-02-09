require "extensions/string"
require "zelig/middleware"
require "zelig/mock_route"
require "zelig/spec_helpers"
require "zelig/version"
require "zelig/rspec"

module Zelig
  class << self
    attr_accessor :output_dir, :service_name

    def configure
      yield self
    end

    def fixture_dir
      File.join(output_dir, "fixtures").to_s
    end

    def descriptor_file
      File.join(output_dir, "descriptor.yml").to_s
    end

    def service_mock_file
      File.join(output_dir, "#{service_name}_mock.rb").to_s
    end

    def sham_rack_file
      File.join(output_dir, "sham_rack.rb").to_s
    end
  end
end
