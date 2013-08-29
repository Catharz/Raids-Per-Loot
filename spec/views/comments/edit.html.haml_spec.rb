require 'spec_helper'

describe 'comments/edit' do
  before(:each) do
    @comment = assign(:comment, stub_model(Comment,
      commented_id: 1,
      commented_type: 'Player',
      comment: 'Comment'
    ))
  end

  it 'renders the edit comment form' do
    render


    assert_select 'form[action=?][method=?]', comment_path(@comment), 'post' do
      assert_select 'select#comment_commented_type[name=?]',
                    'comment[commented_type]'
      assert_select 'div.field#commented_field'
      assert_select 'input#datepicker[name=?]', 'comment[comment_date]'
      assert_select 'textarea#comment_comment[name=?]', 'comment[comment]'
    end
  end
end
