require 'spec_helper'

describe "ranks/new.html.erb" do
  before(:each) do
    assign(:rank, stub_model(Rank,
      :name => "MyString",
      :priority => 1
    ).as_new_record)
  end

  it "renders new rank form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => ranks_path, :method => "post" do
      assert_select "input#rank_name", :name => "rank[name]"
      assert_select "input#rank_priority", :name => "rank[priority]"
    end
  end
end
