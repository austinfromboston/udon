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
      @example.topics = [ 'cheese', 'bread']
      @example.topics.should == ['cheese', 'bread']
    end

    it "accepts hashes and translates them as arrays" do
      @example.is_a?(Udon::Data::CheckboxTopic).should be_true
      puts @example.class.ancestors.inspect
      @example.topics = { :ch => 'cheese', :br => 'bread' }
      @example.topics.should include('cheese')
      @example.topics.should include('bread')
      @example.topics.size.should == 2
    end

    it "handles mass assignment as well" do
      @example.attributes = { :topics => { :ch => 'cheese', :br => 'bread' } }
      @example.topics.should include('cheese')
      @example.topics.should include('bread')
      @example.topics.size.should == 2
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
