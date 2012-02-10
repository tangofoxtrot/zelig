require 'spec_helper'
require 'lib/zelig'

describe Zelig::Middleware do
  describe "generating the middleware" do
    let(:descriptor) do
      {
        "/links" => {
          "get" => {
            "200" => {
              "fixture_path" => "fixture_path.fixture",
              "description" => "description"
            },

            "default" => {
              "fixture_path" => "fixture_path.fixture",
              "description" => "description"
            }
          }
        }
      }
    end

    before do
      Zelig.configure do |config|
        config.service_name = "test_service" 
        config.output_dir = "test_dir"
      end

      mock(File).open(Zelig.descriptor_file)
      mock(YAML).load(anything) { descriptor }
    end

    describe "generating a service mock" do
      let(:fake_file) { StringIO.new }
      before do
        mock(File).open(Zelig.service_mock_file, "w") do |*args|
          args.last.call(fake_file)
        end
        mock(File).open(Zelig.sham_rack_file, "w")

        Zelig::Middleware.generate
      end

      it "writes the service mock to a file" do
        # see expections in before block
      end

      it "generates a valid service mock" do
        eval(fake_file.string)
        expect { TestServiceMock }.to_not raise_exception NameError
        TestServiceMock.expected_status.should == "default"
      end
    end

    describe "generating the sinatra mock app" do
      let(:service_mock_fake_file) { StringIO.new }
      let(:sham_rack_fake_file) { StringIO.new }

      before do
        mock(File).open(Zelig.service_mock_file, "w") do |*args|
          args.last.call(service_mock_fake_file)
        end

        mock(File).open(Zelig.sham_rack_file, "w") do |*args|
          stub(File).read("fixture_path.fixture")  { "CONTENT" }
          args.last.call(sham_rack_fake_file)
        end

        Zelig::Middleware.generate
      end

      it "writes a sham rack sinatra app" do
        #see expectations in before block
      end

      it "registers a sinatra app with sham rack" do
        eval(service_mock_fake_file.string)
        eval(sham_rack_fake_file.string)

       ShamRack.application_for("#{Zelig.service_name}.test").should be
      end
    end
  end
end
