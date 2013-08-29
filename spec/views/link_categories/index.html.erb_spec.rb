require 'spec_helper'

describe 'link_categories/index.html.erb' do
  before(:each) do
    assign(:link_categories, [
        stub_model(LinkCategory,
                   :title => 'Title',
                   :description => 'Description'
        ),
        stub_model(LinkCategory,
                   :title => 'Title',
                   :description => 'Description'
        )
    ])
  end

  it 'renders a list of link_categories' do
    render

    assert_select 'tr>td', :text => 'Title'.to_s, :count => 2

    assert_select 'tr>td', :text => 'Description'.to_s, :count => 2
  end
end
