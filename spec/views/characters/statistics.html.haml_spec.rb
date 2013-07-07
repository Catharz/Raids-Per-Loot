require 'spec_helper'
require 'character_spec_helper'

describe 'characters/statistics.html.haml' do
  include CharacterSpecHelper
  fixtures :archetypes

  it 'should render the tabs' do
    assign(:characters, [])
    render

    rendered.should contain 'Raid Mains'
    rendered.should contain 'Raid Alts'
    rendered.should contain 'General Alts'
    rendered.should contain 'All'
  end

  it 'should render all the headings' do
    assign(:characters, [])
    render

    rendered.should contain 'Name'
    rendered.should contain 'Class'
    rendered.should contain 'Level'
    rendered.should contain 'AAs'
    rendered.should contain 'Health'
    rendered.should contain 'Power'
    rendered.should contain 'Crit'
    rendered.should contain 'Crit Bonus'
    rendered.should contain 'Potency'
    rendered.should contain 'Adornments'
  end

  context 'rendering data' do
    let(:char1) { FactoryGirl.create(:character, name: 'Betty') }
    let(:char2) { FactoryGirl.create(:character, name: 'Wilma') }
    before(:each) do
      assign(:characters, [char1, char2])
    end

    it 'should render the characters names' do
      render

      rendered.should contain 'Betty'
      rendered.should contain 'Wilma'
    end

    it 'should render the characters classes' do
      char1.should_receive(:archetype_name).and_return('Monk')
      char1.should_receive(:archetype_name).and_return('Templar')

      render

      rendered.should contain 'Monk'
      rendered.should contain 'Templar'
    end

    it 'should render the characters level' do
      char1.should_receive(:level).twice.and_return(55)
      char2.should_receive(:level).twice.and_return(66)

      render

      rendered.should contain '55'
      rendered.should contain '66'
    end

    it 'should render the characters AAs' do
      char1.should_receive(:alternate_advancement_points).twice.and_return(289)
      char2.should_receive(:alternate_advancement_points).twice.and_return(301)

      render

      rendered.should contain '289'
      rendered.should contain '301'
    end

    it 'should render the characters health' do
      char1.should_receive(:health).at_least(2).times.and_return(46123)
      char2.should_receive(:health).at_least(2).times.and_return(39456)

      render

      rendered.should contain '46123'
      rendered.should contain '39456'
    end

    it 'should render the characters power' do
      char1.should_receive(:power).at_least(2).times.and_return(32145)
      char2.should_receive(:power).at_least(2).times.and_return(33456)

      render

      rendered.should contain '32145'
      rendered.should contain '33456'
    end

    it 'should render the characters critical chance' do
      char1.should_receive(:critical_chance).at_least(2).times.and_return(293.05)
      char2.should_receive(:critical_chance).at_least(2).times.and_return(285.01)

      render

      rendered.should contain '293.05'
      rendered.should contain '285.01'
    end

    it 'should render the characters critical bonus' do
      char1.should_receive(:crit_bonus).at_least(2).times.and_return(203.05)
      char2.should_receive(:crit_bonus).at_least(2).times.and_return(215.01)

      render

      rendered.should contain '203.05'
      rendered.should contain '215.01'
    end

    it 'should render the characters potency' do
      char1.should_receive(:potency).at_least(2).times.and_return(123.45)
      char2.should_receive(:potency).at_least(2).times.and_return(234.56)

      render

      rendered.should contain '123.45'
      rendered.should contain '234.56'
    end

    context 'adornments' do
      it 'renders the percentages' do
        char1.should_receive(:adornment_pct).at_least(1).times.and_return(50.00)
        char2.should_receive(:adornment_pct).at_least(1).times.and_return(33.33)
        render

        rendered.should contain '50.00'
        rendered.should contain '33.33'
      end

      it 'counts adornments' do
        char1.should_receive(:count_adornments).with('blue').at_least(2).times.and_return([3, 1])
        char1.should_receive(:count_adornments).with('white').at_least(2).times.and_return([5, 1])
        char1.should_receive(:count_adornments).with('yellow').at_least(2).times.and_return([3, 2])
        char1.should_receive(:count_adornments).with('red').at_least(2).times.and_return([2, 1])
        char1.should_receive(:count_adornments).with('green').at_least(2).times.and_return([3, 3])
        char1.should_receive(:count_adornments).with(nil).at_least(2).times.and_return([19, 9])

        render

        rendered.should have_selector('tr', :'data-blue_adornments' => '1 / 3')
        rendered.should have_selector('tr', :'data-white_adornments' => '1 / 5')
        rendered.should have_selector('tr', :'data-yellow_adornments' => '2 / 3')
        rendered.should have_selector('tr', :'data-red_adornments' => '1 / 2')
        rendered.should have_selector('tr', :'data-green_adornments' => '3 / 3')
      end
    end
  end
end