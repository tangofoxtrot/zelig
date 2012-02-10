require 'spec_helper'
require 'lib/zelig'

describe Zelig::MockRoute do
  let(:mock_route) { Zelig::MockRoute.new("/links/:id") }

  before do
    Zelig.configure { |config|  config.output_dir = "test_dir" }
  end

  describe "finding the default fixture" do
    let(:responses) do
      r = Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
      r['200'] = { 'fixture_path' => '200' }
      r['404'] = { 'fixture_path' => '404' }
      r
    end

    it "returns the default" do
      responses.merge!('default' => { 'fixture_path' => 'default' })
      Zelig::MockRoute.default_fixture(responses).should == 'default'
    end

    it "returns the lowest response code if there is no default" do
      Zelig::MockRoute.default_fixture(responses).should == '200'
    end
  end

  describe "mocking a routes response" do
    context "by default" do
      it "writes the fixture" do
        mock(File).open.with_any_args do |*args|
          args[0].should == "test_dir/lib/fixtures/200_links_id.fixture"
          args[1].should == "w"

          file_mock = Object.new
          mock(file_mock).write("CONTENT")
          args[2].call(file_mock)
        end
        mock_route.respond_with(200, "CONTENT")
      end

      it "generates a description" do
        mock(File).open.with_any_args
        mock_route.respond_with(200, "CONTENT")
        mock_route.response['200']['description'].should == "200 response for /links/:id"
      end

      it "generates the fixture path" do
        mock(File).open.with_any_args
        mock_route.respond_with(200, "CONTENT")
        mock_route.response['200']['fixture_path'].should == "test_dir/lib/fixtures/200_links_id.fixture"
      end

    end

    context "with options" do
      before do
        mock(File).open.with_any_args
        mock_route.respond_with(200, "CONTENT", :description => "description", :default => true)
      end

      it "uses the supplied description" do
        mock_route.response['200']['description'].should == "description"
      end

      it "accepts a default option" do
        mock_route.response['default']['description'].should == "description"
        mock_route.response['default']['fixture_path'].should == "test_dir/lib/fixtures/200_links_id.fixture"
      end
    end
  end
end
