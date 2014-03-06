require 'spec_helper'
require 'authentication_spec_helper'

describe 'links/index' do
  include AuthenticationSpecHelper
  fixtures :users, :services

  before(:each) do
    login_as :admin
    category1 = stub_model(LinkCategory, title: 'Blah 1',
                           description: 'Blah Blah 1')
    category2 = stub_model(LinkCategory, title: 'Blah 2',
                           description: 'Blah Blah 2')
    assign(:links, [
        stub_model(Link,
                   url: 'Url 1',
                   title: 'Title 1',
                   description: 'MyText 1',
                   link_category_id: category1.id
        ),
        stub_model(Link,
                   url: 'Url 2',
                   title: 'Title 2',
                   description: 'MyText 2',
                   link_category_id: category2.id
        )
    ])
  end

  it 'renders a list of links' do
    render
    assert_select 'tr>td', text: 'Url 1'.to_s, count: 1
    assert_select 'tr>td', text: 'Title 1'.to_s, count: 1
    assert_select 'tr>td', text: 'MyText 1'.to_s, count: 1
    assert_select 'tr>td', text: 'Url 2'.to_s, count: 1
    assert_select 'tr>td', text: 'Title 2'.to_s, count: 1
    assert_select 'tr>td', text: 'MyText 2'.to_s, count: 1
  end
end
