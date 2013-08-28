require 'spec_helper'

describe 'slots/index.html.erb' do
  before(:each) do
    assign(:slots, [
      stub_model(Slot,
        :name => 'Arm'
      ),
      stub_model(Slot,
        :name => 'Leg'
      )
    ])
  end

  it 'renders a list of slots' do
    render

    assert_select 'table#dataTable' do
      assert_select 'tbody' do
        assert_select 'tr>td', text: 'Arm', count: 1
        assert_select 'tr>td', text: 'Leg', count: 1
      end
    end
  end
end
