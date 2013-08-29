require 'spec_helper'

describe 'zones/index.html.erb' do
  before(:each) do
    easy = stub_model(Difficulty, name: 'Easy', rating: 1)
    normal = stub_model(Difficulty, name: 'Normal', rating: 2)
    hard = stub_model(Difficulty, name: 'Hard', rating: 3)
    assign(:difficulties, [easy, normal, hard])
    assign(:zones, [
        stub_model(Zone,
                   name: 'Name',
                   difficulty: easy
        ),
        stub_model(Zone,
                   name: 'Name',
                   difficulty: hard
        )
    ])
  end

  it 'renders a list of zones' do
    render

    assert_select 'table#zonesTable' do
      assert_select 'tbody>tr' do
        assert_select 'tr>td', text: 'Name', count: 2
        assert_select 'tr>td', text: 'Easy', count: 1
        assert_select 'tr>td', text: 'Hard', count: 1
      end
    end
  end
end
