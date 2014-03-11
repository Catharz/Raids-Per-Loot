require 'spec_helper'

describe 'loot_types/edit' do
  before(:each) do
    @loot_type = assign(:loot_type, stub_model(LootType,
      name: 'MyString', default_loot_method: 'n'
    ))
  end

  it 'renders the edit loot_type form' do
    render

    assert_select 'form', action: loot_types_path(@loot_type),
                  method: 'post' do |form|

      form.should have_selector('input', type: 'submit')
      form.should have_selector('input', name: 'loot_type[name]')
      form.should have_selector('select',
                                name: 'loot_type[default_loot_method]',
                                id: 'loot_type_default_loot_method')
    end
  end
end
