require File.expand_path( File.dirname(__FILE__)) + '/../../spec_helper.rb'
require 'spec/fixtures/udon_example'

describe Udon::AccountConfiguration do
  before do
    @config = UdonExample.config
  end

  it "does not save objects missing required fields" do
    ex = UdonExample.new :roles => [ "Parent" ]
    ex.should_not be_valid
  end

  it "does save objects with required values present" do
    ex = UdonExample.new :roles => [ "Parent" ], :email => 'test@example.com'
    ex.should be_valid
  end

end
