require 'spec_helper'
require 'character_spec_helper'

describe "characters/statistics.html.haml" do
  include CharacterSpecHelper

  it "should render the tabs" do
    assign(:characters, [])
    render

    rendered.should contain "Raid Mains"
    rendered.should contain "Raid Alts"
    rendered.should contain "General Alts"
    rendered.should contain "All"
  end

  it "should render all the headings" do
    assign(:characters, [])
    render

    rendered.should contain "Name"
    rendered.should contain "Class"
    rendered.should contain "Level"
    rendered.should contain "AAs"
    rendered.should contain "Health"
    rendered.should contain "Power"
    rendered.should contain "Crit"
    rendered.should contain "Crit Bonus"
    rendered.should contain "Potency"
    rendered.should contain "Adornments"
    rendered.should contain "White"
    rendered.should contain "Yellow"
    rendered.should contain "Red"
    rendered.should contain "Green"
    rendered.should contain "Blue"
  end

  it "should render the characters names" do
    assign(:characters, [valid_soe_attributes('name' => 'Fred'), valid_soe_attributes('name' => 'Barney')])
    render

    rendered.should contain "Fred"
    rendered.should contain "Barney"
  end

  it "should render the characters classes" do
    char1 = valid_soe_attributes('name' => 'Betty', 'type' => {'class' => 'Monk'})
    char2 = valid_soe_attributes('name' => 'Wilma', 'type' => {'class' => 'Templar'})
    assign(:characters, [char1, char2])
    render

    rendered.should contain "Monk"
    rendered.should contain "Templar"
  end

  it "should render the characters level" do
    char1 = valid_soe_attributes('name' => 'Betty', 'type' => {'level' => 55})
    char2 = valid_soe_attributes('name' => 'Wilma', 'type' => {'level' => 66})
    assign(:characters, [char1, char2])
    render

    rendered.should contain "55"
    rendered.should contain "66"
  end

  it "should render the characters AAs" do
    char1 = valid_soe_attributes('name' => 'Betty', 'alternateadvancements' => {'spentpoints' => 280, 'availablepoints' => 9})
    char2 = valid_soe_attributes('name' => 'Wilma', 'alternateadvancements' => {'spentpoints' => 290, 'availablepoints' => 11})
    assign(:characters, [char1, char2])
    render

    rendered.should contain "289"
    rendered.should contain "301"
  end

  it "should render the characters health" do
    char1 = valid_soe_attributes('name' => 'Betty')
    char1['stats'].merge!('health' => {'max' => 46123})
    char2 = valid_soe_attributes('name' => 'Wilma')
    char2['stats'].merge!('health' => {'max' => 39456})
    assign(:characters, [char1, char2])
    render

    rendered.should contain "46123"
    rendered.should contain "39456"
  end

  it "should render the characters power" do
    char1 = valid_soe_attributes('name' => 'Betty')
    char1['stats'].merge!('power' => {'max' => 32145})
    char2 = valid_soe_attributes('name' => 'Wilma')
    char2['stats'].merge!('power' => {'max' => 33456})
    assign(:characters, [char1, char2])
    render

    rendered.should contain "32145"
    rendered.should contain "33456"
  end

  it "should render the characters critical chance" do
    char1 = valid_soe_attributes('name' => 'Betty')
    char1['stats']['combat'].merge!('critchance' => 293.05)
    char2 = valid_soe_attributes('name' => 'Wilma')
    char2['stats']['combat'].merge!('critchance' => 285.01)
    assign(:characters, [char1, char2])
    render

    rendered.should contain "293.05"
    rendered.should contain "285.01"
  end

  it "should render the characters critical bonus" do
    char1 = valid_soe_attributes('name' => 'Betty')
    char1['stats']['combat'].merge!('critbonus' => 203.05)
    char2 = valid_soe_attributes('name' => 'Wilma')
    char2['stats']['combat'].merge!('critbonus' => 215.01)
    assign(:characters, [char1, char2])
    render

    rendered.should contain "203.05"
    rendered.should contain "215.01"
  end

  it "should render the characters potency" do
    char1 = valid_soe_attributes('name' => 'Betty')
    char1['stats']['combat'].merge!('basemodifier' => 123.45)
    char2 = valid_soe_attributes('name' => 'Wilma')
    char2['stats']['combat'].merge!('basemodifier' => 234.56)
    assign(:characters, [char1, char2])
    render

    rendered.should contain "123.45"
    rendered.should contain "234.56"
  end

  it "should render the characters adornment percentages" do
    char1 = valid_soe_attributes('name' => 'Betty', 'equipmentslot_list' => [
        {'item' =>
             {'adornment_list' => [
                 {'color' => 'white', 'id' => '1'},
                 {'color' => 'blue'},
                 {'color' => 'yellow'}
             ]}},
        {'item' =>
             {'adornment_list' => [
                 {'color' => 'white', 'id' => '1'},
                 {'color' => 'green', 'id' => '2'},
                 {'color' => 'yellow'}
             ]}},
        {'item' =>
             {'adornment_list' => [
                 {'color' => 'white', 'id' => '1'},
                 {'color' => 'yellow'}
             ]}}
    ])
    char2 = valid_soe_attributes('name' => 'Wilma', 'equipmentslot_list' => [
        {'item' =>
             {'adornment_list' => [
                 {'color' => 'white', 'id' => '1'},
                 {'color' => 'yellow'},
                 {'color' => 'red'}
             ]}},
        {'item' =>
             {'adornment_list' => [
                 {'color' => 'white'},
                 {'color' => 'white'},
                 {'color' => 'yellow', 'id' => '2'}
             ]}},
        {'item' =>
             {'adornment_list' => [
                 {'color' => 'white'},
                 {'color' => 'white'},
                 {'color' => 'yellow'},
                 {'color' => 'blue', 'id' => '3'},
                 {'color' => 'green', 'id' => '4'},
                 {'color' => 'red'}
             ]}}
    ])
    assign(:characters, [char1, char2])
    render

    rendered.should contain "50.00"
    rendered.should contain "33.33"
  end

  it "should render the characters adornment counts" do
    wilma = valid_soe_attributes('name' => 'Wilma', 'equipmentslot_list' => [
        {'item' =>
             {'adornment_list' => [
                 {'color' => 'white', 'id' => '1'},
                 {'color' => 'yellow'},
                 {'color' => 'red'}
             ]}},
        {'item' =>
             {'adornment_list' => [
                 {'color' => 'white'},
                 {'color' => 'white'},
                 {'color' => 'yellow', 'id' => '2'}
             ]}},
        {'item' =>
             {'adornment_list' => [
                 {'color' => 'white'},
                 {'color' => 'white'},
                 {'color' => 'yellow', 'id' => '3'},
                 {'color' => 'red', 'id' => '4'}
             ]}}
    ])
    assign(:characters, [wilma])
    render

    rendered.should contain "1 / 5"
    rendered.should contain "2 / 3"
    rendered.should contain "1 / 2"
  end
end