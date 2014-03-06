require 'spec_helper'

describe 'links/new.html.erb' do
  before(:each) do
    assign(:link, stub_model(Link,
      url: 'MyString',
      title: 'MyString',
      description: 'MyText'
    ).as_new_record)
  end

  it 'renders new link form' do
    render


    assert_select 'form', action: links_path, method: 'post' do
      assert_select 'input#link_url', name: 'link[url]'
      assert_select 'input#link_title', name: 'link[title]'
      assert_select 'textarea#link_description', name: 'link[description]'
    end
  end
end
