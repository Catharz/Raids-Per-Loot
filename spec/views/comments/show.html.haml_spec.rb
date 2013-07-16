require 'spec_helper'

describe "comments/show" do
  before(:each) do
    player = stub_model(Player, FactoryGirl.attributes_for(:player))
    @comment = assign(:comment, stub_model(Comment, FactoryGirl.attributes_for(:comment, commented: player)))
  end

  it "renders attributes in <p>" do
    render

    rendered.should match 'Player'
    rendered.should match @comment.comment_date.to_s
    rendered.should match @comment.commented_name
    rendered.should match @comment.comment
  end
end
