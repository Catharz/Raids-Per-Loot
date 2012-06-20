require 'spec_helper'

describe "admin/show" do
  it "shows a message describing this page" do
    render

    rendered.should contain "Here you can perform a number of administrative functions and configure the loot system to your liking."
  end

  it "has a link for downloading the guild characters" do
    render

    rendered.should contain "Download All Guild Characters"
  end

  it "has a link for updating all item details" do
    render

    rendered.should contain "Update All Item Details"
  end

  it "has a link for updating all character details" do
    render

    rendered.should contain "Update All Character Details"
  end

end