require 'spec_helper'

describe 'items/new' do
  before(:each) do
    assign(:item, stub_model(Item,
                             name: 'MyString',
                             :eq2_item_id => 'MyString',
                             info_url: 'MyString'
    ).as_new_record)
  end

  it 'renders new item form' do
    render


    assert_select 'form', action: items_path, method: 'post' do
      assert_select 'input#item_name', name: 'item[name]'
      assert_select 'input#item_eq2_item_id', name: 'item[eq2_item_id]'
      assert_select 'input#item_info_url', name: 'item[info_url]'
    end
  end
end
