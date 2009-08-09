require File.dirname(__FILE__) + '/../../spec_helper'
describe Udon::ResourceHelper do
  before do
    helper_class = Class.new do
      attr_accessor :params
      include Udon::ResourceHelper
    end
    @helper = helper_class.new
  end
  it "should drop the collection params" do
    @helper.params = { :collection => 'blah', :good => 'blah' }
    @helper.collection_params.keys.should_not include(:collection)
  end
  it "should drop the collection params with string keys" do
    @helper.params = { 'collection' => 'blah', :good => 'blah' }
    @helper.collection_params.keys.should_not include(:collection)
    @helper.collection_params.keys.should_not include('collection')
  end
end
