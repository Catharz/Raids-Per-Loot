require 'spec_helper'

describe 'link_categories/show.html.erb' do
  before(:each) do
    @link_category = assign(:link_category,
                            stub_model(LinkCategory,
                                       :title => 'Title',
                                       :description => 'Description'
                            ))
  end

  it 'renders attributes in <p>' do
    render

    rendered.should match(/Title/)
    rendered.should match(/Description/)
  end
end
