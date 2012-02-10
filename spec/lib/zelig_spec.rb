require 'spec_helper'
require 'lib/zelig'

describe Zelig do
  describe "configuring" do
    before do
      Zelig.configure do |config|
        config.service_name = "test_service"
        config.output_dir = "test_dir"
      end
    end

    it "accepts the service name" do
      Zelig.service_name.should == "test_service"
    end

    it "accepts the output directory" do
      Zelig.output_dir.should == "test_dir"
    end

    it "generates the fixture directory" do
      Zelig.fixture_dir.should == "test_dir/lib/fixtures"
    end

    it "generates the service mock file" do
      Zelig.service_mock_file.should == "test_dir/lib/test_service_mock.rb"
    end

    it "generates the descriptor file" do
      Zelig.descriptor_file.should == "test_dir/lib/descriptor.yml"
    end

    it "generates the sham rack file" do
      Zelig.sham_rack_file.should == "test_dir/lib/test_service_mock/sham_rack.rb"
    end
  end
end
