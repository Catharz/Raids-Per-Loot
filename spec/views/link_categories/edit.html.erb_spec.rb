require 'spec_helper'

describe 'link_categories/edit.html.erb' do
  before(:each) do
    @link_category = assign(:link_category,
                            stub_model(LinkCategory,
                                       title: 'Title',
                                       description: 'Description'
                            ))
  end

  it 'renders the edit link_category form' do
    render


    assert_select 'form', action: link_categories_path(@link_category),
                  method: 'post' do
      assert_select 'input#link_category_title',
                    name: 'link_category[title]'
      assert_select 'textarea#link_category_description',
                    name: 'link_category[description]'
    end
  end
end
