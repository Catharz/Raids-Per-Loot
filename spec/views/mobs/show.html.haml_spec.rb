require 'spec_helper'

describe 'mobs/show' do
  before(:each) do
    easy = stub_model(Difficulty, name: 'Easy', rating: 1)
    normal = stub_model(Difficulty, name: 'Normal', rating: 2)
    hard = stub_model(Difficulty, name: 'Hard', rating: 3)
    assign(:difficulties, [easy, normal, hard])
    @mob = assign(:mob, stub_model(Mob,
                                   name: 'Name',
                                   strategy: 'MyText',
                                   difficulty: easy
    ))
    @mob.stub(:items).and_return([])
    @mob.stub(:drops).and_return([])
  end

  it 'renders headings' do
    render

    rendered.should contain('Details')
    rendered.should contain('Items')
    rendered.should contain('Drops')
  end
end
