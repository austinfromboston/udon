require File.expand_path( File.dirname(__FILE__)) + '/../../spec_helper.rb'
require 'spec/fixtures/udon_example'

describe Udon::FormField do
  before do
    @config = UdonExample.config
  end

  it "creates reasonable default labels for fields" do
    @config[:first_name].label.should match( /First Name/ )
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
end
