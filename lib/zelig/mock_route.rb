module Zelig
  class MockRoute
    attr_reader :route, :response

    def initialize route
      @route = route
      @response = {}
    end
  end
end
