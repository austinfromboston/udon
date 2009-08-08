require File.expand_path( File.dirname(__FILE__)) + '/../../spec_helper.rb'
require 'spec/fixtures/udon_example'

describe Udon::CollectionConfiguration do
  before do
    @config = UdonExample.config
  end

  it "creates reasonable default labels for fields" do
    @config[:first_name].label.should match( /First Name/ )
  end

  it "creates label tags too" do
    @config[:first_name].label.should match( /label for.*first_name/ )
  end

  it "accepts custom labels for fields" do
    @config.assign do
      text :email, :label => "Email Correspondence"
    end
    @config[:email].label.should match( /Email Correspondence/ )
  end

  it "accepts empty labels" do
    @config.assign { text :email, :label => false }
    @config[:email].label.should be_blank
  end

  describe "checkboxes" do
    it "knows its plural nature" do
      @config[:roles].should be_plural
    end

    it "has a collection of segments" do
      @config[:roles].segments.first.name.should == 'roles[parent]'
    end



  end

  describe "collection class" do
    before do
      @example = UdonExample.new 
      @example.email = 'udon@example.org'
    end
    it "does not save values from undefined keys" do
      @example.attributes = { :fake_attr => 'item' }
      lambda{ @example.fake_attr }.should raise_error( NoMethodError )
    end
  end

  describe "form proxy" do
    before do
      @example = UdonExample.new 
      @example.email = 'udon@example.org'
      @example.roles = [ 'Parent' ]
      @form_config = @config.form_proxy @example
    end
    it "returns populated version of itself" do
      @form_config[:email].value.should == @example.email
    end

    it "does not pollute the config object with values" do
      @config[:email].value.should be_nil
    end


    describe "checkboxes" do
      it "keeps a boolean value for each segment" do
        @form_config[:roles].segments.first.value.should be_true
      end
    end

  end
end
