require 'spec_helper'

describe 'pages/edit' do
  before(:each) do
    @page = assign(:page, stub_model(Page,
      name: 'MyString',
      title: 'MyString',
      body: 'MyText'
    ))
  end

  it 'renders the edit page form' do
    render

    assert_select 'form', action: pages_path(@page), method: 'post' do
      assert_select 'input#page_name', name: 'page[name]'
      assert_select 'input#page_title', name: 'page[title]'
      assert_select 'textarea#page_body', name: 'page[body]'
    end
  end
end
