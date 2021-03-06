require 'spec_helper'

describe 'pages/index' do
  before(:each) do
    assign(:pages, [
      stub_model(Page,
        name: 'Name',
        title: 'Title',
        body: 'MyText'
      ),
      stub_model(Page,
        name: 'Name',
        title: 'Title',
        body: 'MyText'
      )
    ])
  end

  it 'renders a list of pages' do
    render
    assert_select 'tr>td', text: 'Name'.to_s, count: 2
    assert_select 'tr>td', text: 'Title'.to_s, count: 2
  end
end
