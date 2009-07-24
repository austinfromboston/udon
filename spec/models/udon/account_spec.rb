require File.expand_path( File.dirname(__FILE__)) + '/../../spec_helper.rb'

describe Udon::Account do 
  describe "configuration" do
    before do
      @config = Udon::Account.configure do |config|
        config.database = 'greenschools'
        config.collection :subscriptions do
          text :email
        end
      end
      @config.collection(:subscriptions).insert( :a => 1)

    end
    describe "databases" do
      it "creates databases as needed" do
        MongoMapper.database.name.should == @config.db_database_name('greenschools')
      end
    end

    describe "collections" do
      it "creates collections as needed" do
        MongoMapper.database.collection_names.should include( @config.db_collection_name(:subscriptions) )
      end
    end


    describe "models" do
      it "creates models as needed" do
        Object.const_defined?("Subscription").should be_true
      end
      it "creates Udon::Data models" do
        @sub = Subscription.new
        @sub.is_a?(Udon::Data).should be_true
      end

      describe "text columns" do
        it "accepts assigned values" do
          @sub = Subscription.new
          @sub.email = "test@example.com"
          @sub.email.should == "test@example.com"
        end
      end
    end
  end
end
