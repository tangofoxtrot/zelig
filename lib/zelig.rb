require "fileutils"
require "extensions/string"
require "zelig/middleware"
require "zelig/mock_route"
require "zelig/spec_helpers"
require "zelig/version"

module Zelig
  class << self
    attr_accessor :output_dir, :service_name

    def configure
      yield self
    end

    def service_name=(service_name)
      @service_name = service_name.to_s
    end

    def prepare_output_dir
      FileUtils.mkdir_p fixture_dir
      FileUtils.mkdir_p File.join(output_dir, "lib", "#{service_name}_mock").to_s
    end

    def fixture_dir
      File.join(output_dir, "lib", "fixtures").to_s
    end

    def descriptor_file
      File.join(output_dir, "lib", "descriptor.yml").to_s
    end

    def service_mock_file
      File.join(output_dir, "lib", "#{service_name}_mock.rb").to_s
    end

    def sham_rack_file
      File.join(output_dir, "lib", "#{service_name}_mock", "sham_rack.rb").to_s
    end
  end
end

load 'tasks/zelig.rake'
