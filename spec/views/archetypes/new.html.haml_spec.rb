require 'spec_helper'

describe 'archetypes/new' do
  before(:each) do
    assign(:archetype, stub_model(Archetype, name: 'Name').as_new_record)
  end

  it 'renders new archetype form' do
    render

    assert_select 'form', action: archetypes_path, method: 'post' do
      assert_select 'input#archetype_name', name: 'archetype[name]'
    end
  end
end
