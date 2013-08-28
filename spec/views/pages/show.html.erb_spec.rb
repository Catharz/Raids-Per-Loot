require 'spec_helper'

describe 'pages/show.html.erb' do
  before(:each) do
    @page = assign(:page, stub_model(Page,
      name: 'Name',
      title: 'Title',
      body: 'MyText'
    ))
  end

  it 'renders attributes in <p>' do
    render
    rendered.should match(/Name/)
    rendered.should match(/Title/)
    rendered.should match(/MyText/)
  end
end
