require 'spec_helper'

describe "drops/show.html.erb" do
  fixtures :users
  before(:each) do
    login_as users(:quentin)

    @drop = assign(:drop, stub_model(Drop,
      :zone_name => "Zone Name",
      :mob_name => "Mob Name",
      :character_name => "Character Name",
      :item_name => "Item Name",
      :eq2_item_id => "Eq2 Item"
    ))
  end

  it "renders attributes in <p>" do
    render

    rendered.should match(/Zone Name/)
    rendered.should match(/Mob Name/)
    rendered.should match(/Character Name/)
    rendered.should match(/Item Name/)
    rendered.should match(/Eq2 Item/)
  end
end
