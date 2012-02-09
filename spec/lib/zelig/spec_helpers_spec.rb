require 'spec_helper'
require 'lib/zelig'

describe Zelig::SpecHelpers do
  let(:fixture_builder) { Object.new.extend Zelig::SpecHelpers }

  describe "mocking a route" do
    it "only accepts four http verbs" do
      expect { fixture_builder.mock_route(:get, "/test") {} }.to_not raise_exception(ArgumentError)
      expect { fixture_builder.mock_route(:post, "/test") {} }.to_not raise_exception(ArgumentError)
      expect { fixture_builder.mock_route(:put, "/test") {} }.to_not raise_exception(ArgumentError)
      expect { fixture_builder.mock_route(:delete, "/test") {} }.to_not raise_exception(ArgumentError)
      expect { fixture_builder.mock_route(:options, "/test") {} }.to raise_exception(ArgumentError)
    end

    it "executes the block in the context of a mock route helper" do
      executed_in = nil
      fixture_builder.mock_route :get, "/test" do
        executed_in = self.class
      end

      executed_in.should == Zelig::MockRoute
    end

    it "builds the response hash" do
      response = fixture_builder.mock_route(:get, "/test") {}
      response['/test'].should be_a(Hash)
      response['/test']['get'].should be_a(Hash)
    end

    it "doesn't override a previously configured response" do
      any_instance_of(Zelig::MockRoute) do |mock_route|
        mock(mock_route).response { {:foo => "foo"} }
        mock(mock_route).response { {:bar => "bar"} }
      end

      response = fixture_builder.mock_route(:get, "/test") {}
      response = fixture_builder.mock_route(:get, "/test") {}
      response['/test']['get'].should == { :foo => "foo", :bar => "bar" }
    end
  end

  describe "writing the descriptor file" do
    before do
      Zelig.configure { |config| config.output_dir = "test_dir" }
    end

    it "creates a yaml representation of the routing mocks" do
      mock(File).open.with_any_args do |*args|
        args[0].should == Zelig.descriptor_file
        args[1].should == "w"
        args[2].call(Zelig)
      end
      mock(YAML).dump(is_a(Hash), Zelig)

      fixture_builder.write_descriptor
    end
  end
end
