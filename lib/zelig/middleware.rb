require 'erb'

module Zelig
  module Middleware
    class << self
      def generate
        @descriptor = YAML.load File.open(Zelig.descriptor_file)
        Zelig.prepare_output_dir
        write_service_mock
        write_sham_rack_app
      end

      private 
      attr_reader :descriptor

      def write_service_mock
        template = template_for "service_mock"
        service_mock_file = File.open(Zelig.service_mock_file, "w") do |file| 
          service_class = Zelig.service_name.camelize
          file.write template.result(binding)
        end
      end

      def write_sham_rack_app
        template = template_for "sham_rack"
        service_mock_file = File.open(Zelig.sham_rack_file, "w") do |file| 
          service_class = Zelig.service_name.camelize
          service_host = "#{Zelig.service_name}.test"
          file.write template.result(binding)
        end
      end

      def template_for template
        ERB.new File.read(File.join(File.dirname(__FILE__), "..", "templates", "#{template}.erb")) #, nil, "<>"
      end
    end
  end
end
