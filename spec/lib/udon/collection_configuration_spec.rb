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
    @config[:first_name].label.should match( /label for.{0,3}first_name/ )
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

  it "generates controls" do
    @config[:email].control.should match( /<input.*name='email'/ )
  end

  it "makes submit buttons" do
    @config.submit( "Foo" ).should match(/input.*type=.*submit/)
  end

  describe "checkboxes" do
    it "knows its plural nature" do
      @config[:roles].should be_plural
    end

    it "has a collection of segments" do
      @config[:roles].segments.first.name.should == 'roles[parent]'
    end

    it "makes ok checkbox elements" do
      @config[:roles].segments.first.control.should match(/input.*type='checkbox'/)
    end


  end
end
