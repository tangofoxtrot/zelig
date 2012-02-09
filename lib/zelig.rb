require "zelig/version"

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
  end
end
