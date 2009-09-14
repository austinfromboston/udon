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

    it "does not save objects missing required fields" do
      ex = UdonExample.new :roles => [ "Parent" ]
      ex.should_not be_valid
    end

    it "does save objects with required values present" do
      ex = UdonExample.new :roles => [ "Parent" ], :email => 'test@example.com'
      ex.should be_valid
    end

    describe "dia introspection" do
      before do
        UdonExample.notify :democracy_in_action, :as => "supporter"
        @ex = UdonExample.new :roles => [ 'Parent' ], :email => 'test@example.com', :first_name => 'Eggmont'
      end
      it "polls dia keys" do
        @ex.democracy_in_action.supporter.keys.should include("supporter_KEY")
      end

      it "converts keys to dia forms" do
        @ex.class.services[:democracy_in_action].first.dia_data(@ex).keys.should include("Email")
      end

    end

    describe "pubsub" do
      before do
        @keys = DemocracyInAction::API.new( {} ).supporter.keys
        UdonExample.notify :democracy_in_action, :as => "supporter"
        @ex = UdonExample.new :roles => [ 'Parent' ], :email => 'test@example.com', :first_name => 'Eggmont'
        @supporter_proxy = stub(:supporter_proxy, :keys => @keys)
        @dia = stub(:dia_api, :supporter => @supporter_proxy )
        Udon::Account.configuration.services.should_receive(:[]).with(:democracy_in_action).any_number_of_times.and_return(@dia)
        
      end

      it "sends data to the dia service" do
        #@dia.should_receive(:supporter).any_number_of_times.and_return(@supporter_proxy)
        @supporter_proxy.should_receive(:save).any_number_of_times.with( hash_including( { 'Email' => 'test@example.com', 'First_Name' => 'Eggmont' } ))
        @ex.save

      end

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

    describe "file fields" do
      it "adds a field object" do
        @form_config[:report].should be_a(Udon::FormField)
      end
    end

  end
end
