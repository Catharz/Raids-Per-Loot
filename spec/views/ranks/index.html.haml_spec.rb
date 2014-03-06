require 'spec_helper'

describe 'ranks/index.html.erb' do
  before(:each) do
    assign(:ranks, [
      stub_model(Rank,
        name: 'Member',
        priority: 2
      ),
      stub_model(Rank,
        name: 'Associate',
        priority: 2
      )
    ])
  end

  it 'renders a list of ranks' do
    render

    assert_select 'table#ranksTable tbody' do
      assert_select 'tr>td', text: 'Member', count: 1
      assert_select 'tr>td', text: 'Associate', count: 1
      assert_select 'tr>td', text: 2.to_s, count: 2
    end
  end
end
