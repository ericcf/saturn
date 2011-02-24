require 'spec_helper'

describe "shared/_flash_banner.html" do

  it do
    flash[:foo] = "bar"
    render
    rendered.should have_selector("div.flash.foo", :content => "bar")
  end
end
