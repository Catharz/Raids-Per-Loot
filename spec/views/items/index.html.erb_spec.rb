require 'spec_helper'

describe 'items/index.html.erb' do
  before(:each) do
    assign(:items, [
        stub_model(Item,
                   name: 'Item 1',
                   :eq2_item_id => 'Eq2 Item-1',
                   info_url: 'Info Url 1'
        ),
        stub_model(Item,
                   name: 'Item 2',
                   :eq2_item_id => 'Eq2 Item-2',
                   info_url: 'Info Url 2'
        )
    ])
  end

  it 'renders the table headings' do
    render

    rendered.should contain('Name')
    rendered.should contain('Loot Type')
    rendered.should contain('Slot(s)')
    rendered.should contain('Class(es)')
  end
end
