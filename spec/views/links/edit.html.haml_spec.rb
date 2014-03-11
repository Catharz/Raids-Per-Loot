require 'spec_helper'

describe 'links/edit' do
  before(:each) do
    @link = assign(:link, stub_model(Link,
      url: 'MyString',
      title: 'MyString',
      description: 'MyText'
    ))
  end

  it 'renders the edit link form' do
    render


    assert_select 'form', action: links_path(@link), method: 'post' do
      assert_select 'input#link_url', name: 'link[url]'
      assert_select 'input#link_title', name: 'link[title]'
      assert_select 'textarea#link_description', name: 'link[description]'
    end
  end
end
