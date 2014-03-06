require 'spec_helper'

describe 'ranks/edit' do
  before(:each) do
    @rank = assign(:rank, stub_model(Rank,
      name: 'Associate',
      priority: 2
    ))
  end

  it 'renders the edit rank form' do
    render

    assert_select 'form', action: ranks_path(@rank), method: 'post' do
      assert_select 'input#rank_name', name: 'rank[name]'
      assert_select 'input#rank_priority', name: 'rank[priority]'
    end
  end
end
