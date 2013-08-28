require 'spec_helper'

describe 'pages/new.html.erb' do
  before(:each) do
    assign(:page, stub_model(Page,
      name: 'MyString',
      title: 'MyString',
      body: 'MyText'
    ).as_new_record)
  end

  it 'renders new page form' do
    render

    assert_select 'form', action: pages_path, method: 'post' do
      assert_select 'input#page_name', name: 'page[name]'
      assert_select 'input#page_title', name: 'page[title]'
      assert_select 'textarea#page_body', name: 'page[body]'
    end
  end
end
