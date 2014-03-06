require 'spec_helper'

describe 'mobs/index.html.erb' do
  before(:each) do
    easy = stub_model(Difficulty, name: 'Easy', rating: 1)
    normal = stub_model(Difficulty, name: 'Normal', rating: 2)
    hard = stub_model(Difficulty, name: 'Hard', rating: 3)
    assign(:difficulties, [easy, normal, hard])
    assign(:mobs, [
        stub_model(Mob,
                   name: 'Name',
                   alias: 'Other Name',
                   difficulty: easy
        ),
        stub_model(Mob,
                   name: 'Name',
                   alias: 'Other Name',
                   difficulty: hard
        )
    ])
  end

  it 'renders a list of mobs' do
    render

    assert_select 'tr>td', text: 'Name'.to_s, count: 2
    assert_select 'tr>td', text: 'Other Name'.to_s, count: 2
  end
end
