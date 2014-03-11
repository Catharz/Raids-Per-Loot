require 'spec_helper'

describe 'ranks/show' do
  before(:each) do
    @rank = assign(:rank, stub_model(Rank,
      name: 'Officer',
      priority: 1
    ))
  end

  it 'renders attributes in <p>' do
    render

    rendered.should match(/Officer/)
    rendered.should match(/1/)
  end
end
