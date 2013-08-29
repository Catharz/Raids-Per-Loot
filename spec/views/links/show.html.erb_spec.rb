require 'spec_helper'

describe 'links/show.html.erb' do
  before(:each) do
    @link = assign(:link, stub_model(Link,
      :url => 'Url',
      :title => 'Title',
      :description => 'MyText'
    ))
  end

  it 'renders attributes in <p>' do
    render

    rendered.should match(/Url/)

    rendered.should match(/Title/)

    rendered.should match(/MyText/)
  end
end
