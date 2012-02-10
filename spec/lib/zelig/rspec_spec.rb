require 'spec_helper'
require 'lib/zelig'
require 'lib/zelig/rspec'

describe RSpec do
  it "includes the fixture helpers" do
    # why doesn't this work?  whats a better way to test this?
    # should respond_to(:mock_route)
    respond_to?(:mock_route).should be
  end
end
