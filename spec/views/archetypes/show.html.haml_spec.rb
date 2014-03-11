require 'spec_helper'

describe 'archetypes/show' do
  before(:each) do
    @archetype = assign(:archetype, stub_model(Archetype,
      name: 'Name'
    ))
  end

  it 'renders attributes in <p>' do
    render

    rendered.should match(/Name/)
  end
end
