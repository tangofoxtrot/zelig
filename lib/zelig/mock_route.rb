module Zelig
  class MockRoute
    attr_reader :route, :response

    def self.default_fixture(responses)
      fixture = responses['default']
      if fixture.empty?
        default = responses.keys.map { |k| k.to_s }.sort[0]
        fixture = responses[default]
      end
      fixture['fixture_path']
    end

    def initialize route
      @route = route
      @response = Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
    end

    def respond_with status, content, options = {}
      status = status.to_s
      description = options[:description] || description_from(status, route)

      response[status] = {
        'fixture_path' => write_fixture(status, content),
        'description' => description
      }

      response['default'] = response[status] if options[:default]
    end

    private

    def write_fixture status, content
      fixture_path = File.join Zelig.fixture_dir, path_from(status, route)
      File.open(fixture_path, "w") do |file|
        file.write content
      end
      fixture_path.to_s
    end

    def path_from status, route
      path = route.gsub(/:/, '').gsub(/[^[:alnum:]]/, '_')
      "#{status}#{path}.fixture"
    end

    def description_from status, route
      "#{status} response for #{route}"
    end
  end
end
