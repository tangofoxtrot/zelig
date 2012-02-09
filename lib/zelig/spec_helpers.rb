module Zelig
  module SpecHelpers
    def write_descriptor
      File.open(Zelig.descriptor_file, "w") { |file| YAML.dump descriptor, file }
    end

    def mock_route verb, route, &block
      raise ArgumentError unless ['get', 'post', 'put', 'delete'].include? verb.to_s.downcase

      MockRoute.new(route).tap do |mock_route|
        mock_route.instance_eval &block
        descriptor[route.to_s][verb.to_s].merge! mock_route.response
      end
      descriptor
    end

    private

    def descriptor
      @descriptor ||= Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
    end
  end
end
