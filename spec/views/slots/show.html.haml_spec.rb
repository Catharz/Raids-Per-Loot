require 'spec_helper'

describe 'slots/show' do
  before(:each) do
    @slot = assign(:slot, stub_model(Slot,
      name: 'Wrist'
    ))
  end

  it 'renders attributes in <p>' do
    render

    rendered.should match(/Wrist/)
  end
end
