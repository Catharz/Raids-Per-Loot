require 'spec_helper'

describe "comments/index" do
  before(:each) do
    assign(:comments, [
      stub_model(Comment,
        :commented_id => 1,
        :commented_type => "Player",
        :comment => "MyText"
      ),
      stub_model(Comment,
        :commented_id => 1,
        :commented_type => "Player",
        :comment => "MyText"
      )
    ])
  end

  it "renders a list of comments" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Player".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
