require File.dirname(__FILE__) + '/../../spec_helper'

describe Udon::FormHelper do
  before :all do
    @helper = helper_proxy Udon::FormHelper, Udon::RouteHelper
    @ex = UdonExample.new
  end
  it "creates a multipart form" do
    @helper.form_start_tag(@ex).should match(/multipart/)
  end

  it "delivers encoding" do
    @helper.form_encoding(@ex).should match(/multipart/)
  end
end
