require File.expand_path( File.dirname(__FILE__)) + '/../../spec_helper.rb'
require 'spec/fixtures/udon_example'

describe Udon::AccountConfiguration do
  before do
    @config = Udon::AccountConfiguration.new
  end

  describe "service objects" do
    before do
      @service = @config.service( :democracy_in_action ) do |dia|
        dia.login = "demo"
        dia.password= "demo"
        dia.node = :salsa
      end
    end
    it "initializes a service object" do
      @service.should be_an_instance_of DemocracyInAction::API
    end

    it "retains the login info" do
      @service.username.should == "demo"
    end

  end

end
