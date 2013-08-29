require 'spec_helper'

describe 'comments/index' do
  before(:each) do
    assign(:comments, [
      stub_model(Comment,
        commented_id: 1,
        commented_type: 'Player',
        comment: 'Comment'
      ),
      stub_model(Comment,
        commented_id: 1,
        commented_type: 'Player',
        comment: 'Comment'
      )
    ])
  end

  it 'renders a list of comments' do
    render

    assert_select 'tr>td', text: 'Player'.to_s, count: 2
    assert_select 'tr>td', text: 'Comment'.to_s, count: 2
  end
end
