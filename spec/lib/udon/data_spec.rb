require File.expand_path( File.dirname(__FILE__)) + '/../../spec_helper.rb'
require 'spec/fixtures/udon_example'
describe UdonExample do
  before do
    @example = UdonExample.new
  end

  describe "configuration" do
    describe "fields" do
      it "maintains a list" do
        UdonExample.config.fields.should respond_to(:each)
      end
    end

  end

  describe "checkboxes" do
    it "accepts arrays of data" do
      UdonExample.checkboxes :topics, %w[ cheese tomato bread ]
      @example.topics = [ 'cheese', 'bread']
      @example.topics.should == ['cheese', 'bread']
    end
  end

  describe "arguments array" do
    before do 
      @args = [ 1, 2, 3, { :test => 'such' }]
    end
    it "extracts options" do
      @args.extract_options!.should be_instance_of(Hash)
    end

    it "drops extracted hash from arguments list" do
      @args.extract_options!
      @args.size.should == 3
    end
  end



end
