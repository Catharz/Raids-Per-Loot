require 'spec_helper'

describe "comments/new" do
  before(:each) do
    assign(:comment, stub_model(Comment,
      :commented_id => 1,
      :commented_type => "Player",
      :comment => "MyText"
    ).as_new_record)
  end

  it "renders new comment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", comments_path, "post" do
      assert_select "select#comment_commented_type[name=?]", "comment[commented_type]"
      assert_select "div.field#commented_field"
      assert_select "input#datepicker[name=?]", "comment[comment_date]"
      assert_select "textarea#comment_comment[name=?]", "comment[comment]"
    end
  end
end
