require 'spec_helper'
require 'attendance_spec_helper'
require 'character_spec_helper'
require 'drop_spec_helper'

describe "characters/show.html.haml" do
  include AttendanceSpecHelper, CharacterSpecHelper, DropSpecHelper

  let(:character) { mock_model(Character,
                               :name => "Julie",
                               :archetype => mock_model(Archetype, :name => "Mage"),
                               :char_type => "m",
                               :raids => [],
                               :instances => [],
                               :drops => [],
                               :adjustments => []) }

  before(:each) do
    character_list = setup_characters(%w{Julie})
    create_attendance(:num_raids => 2, :num_instances => 3, :attendees => character_list)
    character = assign(:character, character_list.first)

    drop_list = create_drops(character, "Armour" => 2, "Weapon" => 3, "Jewellery" => 1)
    character.stub!(:drops).and_return(drop_list)
    character.stub!(:adjustments).and_return([])
    character.stub!(:armour_rate).and_return(2.0)
    character.stub!(:weapon_rate).and_return(3.6)
    character.stub!(:jewellery_rate).and_return(6.9)
    external_data =
        mock_model(ExternalData,
                   :retrievable_id => character.id,
                   :retrievable_type => "Character",
                   :data => {stats:
                                 {ability: {spelltimecastpct: 16.905919999999998, spelltimerecoverypct: 0.0, spelltimereusepct: 32.300002999999997,
                                            spelltimereusespellonly: 0.0},
                                  agi: {base: 35, effective: 1950},
                                  combat: {abilitymod: 1160.8000489999999, accuracy: 38.799999, aeautoattackchance: 20.0,
                                           attackspeed: 184.96719400000001, baseavoidancebonus: 2.3999999999999999, basemodifier: 200.99998500000001,
                                           blockchance: 60.099995, critbonus: 222.64836099999999, critchance: 293.69998199999998,
                                           doubleattackchance: 603.41992200000004, dps: 108.89997099999999, flurry: 15.0,
                                           hategainmod: 0.0, incombatsavageryregen: 0.0, maxsavagerylevel: 0.0, outofcombatsavageryregen: 0.0,
                                           pvpbasemodifier: 10.0, pvpcritbonus: 19.248360000000002, pvpcriticalmitigation: 0.0,
                                           pvpdoubleattackchance: 62.519989000000002, pvpspelldoubleattackchance: 0.0,
                                           pvptoughness: 0, savagerygainmod: 0.0, savageryregen: 0.0, spelldoubleattackchance: 0.0,
                                           spellweaponaeautoattackchance: 0.0, spellweaponattackspeed: 0.0, spellweapondoubleattackchance: 0.0,
                                           spellweapondps: 0.0, spellweaponflurry: 0.0, strikethrough: 100.0},
                                  defense: {armor: 150, avoidance: 19044, block: 600, parry: 236},
                                  health: {max: 49237, regen: 2159},
                                  int: {base: 15, effective: 271},
                                  personal_status_points: 29560875,
                                  power: {max: 37107, regen: 1640},
                                  runspeed: 50.0,
                                  sta: {base: 28, effective: 3173},
                                  str: {base: 32, effective: 3498},
                                  tradeskill: {critfailuremod: 0.0, critsuccessmod: 1.0, durabilityadd: 0.0, durabilitymod: 0.0,
                                               progressadd: 0.0, progressmod: 2.0, rareharvestchance: 0.0, successmod: 3.0},
                                  weapon: {primarydelay: 2.9838520000000002, primarymaxdamage: 5204, primarymindamage: 1039,
                                           rangeddelay: 4.0282, rangedmaxdamage: 13776, rangedmindamage: 2923, secondarydelay: 2.9838520000000002,
                                           secondarymaxdamage: 4638, secondarymindamage: 926},
                                  wis: {base: 20, effective: 272}}.with_indifferent_access
                   })
    character.stub!(:external_data).and_return(external_data)

    assign(:drop_list, character.drops)
    assign(:instance_list, character.instances)
    assign(:adjustment_list, [])
    assign(:character_types, [])
    assign(:data, external_data)
  end

  it "should show the characters name" do
    render

    rendered.should contain("Name: Julie")
  end

  it "should show the number of raids" do
    render

    rendered.should have_content 'Raids: 2'
  end

  it "should show the number of instances" do
    render

    rendered.should have_content 'Instances: 6'
  end

  it "should show the number of drops" do
    render

    rendered.should contain("Drops: 6")
  end

  it "should show the armour rate" do
    render

    rendered.should contain("Armour Rate: 2.0")
  end

  it "should show the weapon rate" do
    render

    rendered.should contain("Weapon Rate: 3.6")
  end

  it "should show the jewellery rate" do
    render

    rendered.should contain("Jewellery Rate: 6.9")
  end

  it "should render critical chance" do
    render

    rendered.should contain("Critical Chance: 293.699982")
  end
end