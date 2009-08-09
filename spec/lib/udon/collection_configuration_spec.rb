require File.expand_path( File.dirname(__FILE__)) + '/../../spec_helper.rb'
require 'spec/fixtures/udon_example'

describe Udon::CollectionConfiguration do
  before do
    @config = UdonExample.config
  end

  describe "collection class" do
    before do
      @example = UdonExample.new 
      @example.email = 'udon@example.org'
    end
    it "does not save values from undefined keys" do
      lambda{ 
        @example.attributes = { :fake_attr => 'item' }
      }.should raise_error( NoMethodError )
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
