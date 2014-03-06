require 'spec_helper'

describe 'loot_types/new.html.erb' do
  before(:each) do
    assign(:loot_type, stub_model(LootType,
      name: 'MyString'
    ).as_new_record)
  end

  it 'renders new loot_type form' do
    render

    assert_select 'form', action: loot_types_path, method: 'post' do
      assert_select 'input#loot_type_name', name: 'loot_type[name]'
    end
  end
end
