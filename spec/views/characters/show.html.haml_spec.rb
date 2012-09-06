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
    character.stub!(:character_types).and_return([])
    character.stub!(:jewellery_rate).and_return(6.9)
    external_data =
        mock_model(ExternalData,
                   :retrievable_id => character.id,
                   :retrievable_type => "Character",
                   :data => {stats:
                                 {ability: {spelltimecastpct: 16.905919999999998,
                                            spelltimerecoverypct: 0.0,
                                            spelltimereusepct: 32.300002999999997,
                                            spelltimereusespellonly: 0.0},
                                  agi: {base: 35, effective: 1950},
                                  combat: {abilitymod: 1160.8000489999999,
                                           accuracy: 38.799999,
                                           aeautoattackchance: 20.0,
                                           attackspeed: 184.96719400000001,
                                           baseavoidancebonus: 2.3999999999999999,
                                           basemodifier: 200.99998500000001,
                                           blockchance: 60.099995,
                                           critbonus: 222.64836099999999,
                                           critchance: 293.69998199999998,
                                           doubleattackchance: 603.41992200000004,
                                           dps: 108.89997099999999,
                                           flurry: 15.0,
                                           hategainmod: 0.0,
                                           incombatsavageryregen: 0.0,
                                           maxsavagerylevel: 0.0,
                                           outofcombatsavageryregen: 0.0,
                                           pvpbasemodifier: 10.0,
                                           pvpcritbonus: 19.248360000000002,
                                           pvpcriticalmitigation: 0.0,
                                           pvpdoubleattackchance: 62.519989000000002,
                                           pvpspelldoubleattackchance: 0.0,
                                           pvptoughness: 0,
                                           savagerygainmod: 0.0,
                                           savageryregen: 0.0,
                                           spelldoubleattackchance: 0.0,
                                           spellweaponaeautoattackchance: 0.0,
                                           spellweaponattackspeed: 0.0,
                                           spellweapondoubleattackchance: 0.0,
                                           spellweapondps: 0.0,
                                           spellweaponflurry: 0.0,
                                           strikethrough: 100.0},
                                  defense: {armor: 150, avoidance: 19044, block: 600, parry: 236},
                                  health: {max: 49237, regen: 2159},
                                  int: {base: 15, effective: 271},
                                  personal_status_points: 29560875,
                                  power: {max: 37107, regen: 1640},
                                  runspeed: 50.0,
                                  sta: {base: 28, effective: 3173},
                                  str: {base: 32, effective: 3498},
                                  tradeskill: {critfailuremod: 0.0,
                                               critsuccessmod: 1.0,
                                               durabilityadd: 0.0,
                                               durabilitymod: 0.0,
                                               progressadd: 0.0,
                                               progressmod: 2.0,
                                               rareharvestchance: 0.0,
                                               successmod: 3.0},
                                  weapon: {primarydelay: 2.9838520000000002,
                                           primarymaxdamage: 5204,
                                           primarymindamage: 1039,
                                           rangeddelay: 4.0282,
                                           rangedmaxdamage: 13776,
                                           rangedmindamage: 2923,
                                           secondarydelay: 2.9838520000000002,
                                           secondarymaxdamage: 4638,
                                           secondarymindamage: 926},
                                  wis: {base: 20, effective: 272}}.with_indifferent_access
                   })
    character.stub!(:external_data).and_return(external_data)

    assign(:drop_list, character.drops)
    assign(:instance_list, character.instances)
    assign(:adjustment_list, [])
    assign(:character_types, [])
    assign(:data, external_data)
  end

  it "should show the tab headings" do
    render

    rendered.should contain "Details"
    rendered.should contain "Attendance"
    rendered.should contain "Drops"
    rendered.should contain "History"
    rendered.should contain "Adjustments"
    rendered.should contain "Statistics"
  end

  it "should show the characters name" do
    render

    rendered.should contain "Name: Julie"
  end

  it "should show the attendance" do
    render

    rendered.should contain "Raids: 2"
    rendered.should contain "Instances: 6"
  end

  it "should show the loot" do
    render

    rendered.should contain "Drops: 6"
    rendered.should contain "Armour Rate: 2.0"
    rendered.should contain "Weapon Rate: 3.6"
    rendered.should contain "Jewellery Rate: 6.9"
  end

  it "should show the statistics sub-tab headings" do
    render

    rendered.should contain "General"
    rendered.should contain "Offensive"
    rendered.should contain "Defensive"
    rendered.should contain "Casting"
    rendered.should contain "Melee Weapon"
    rendered.should contain "Spell Weapon"
    rendered.should contain "Savagery"
    rendered.should contain "Player Vs Player"
    rendered.should contain "Trade Skill"
  end

  it "should show general statistics" do
    render

    rendered.should contain "Health:"
    rendered.should contain "Max: 49237"
    rendered.should contain "Regen: 2159"

    rendered.should contain "Power:"
    rendered.should contain "Max: 37107"
    rendered.should contain "Regen: 1640"

    rendered.should contain "Agility:"
    rendered.should contain "Base: 35"
    rendered.should contain "Effective: 1950"

    rendered.should contain "Intelligence"
    rendered.should contain "Base: 15"
    rendered.should contain "Effective: 271"

    rendered.should contain "Stamina:"
    rendered.should contain "Base: 28"
    rendered.should contain "Effective: 3173"

    rendered.should contain "Strength:"
    rendered.should contain "Base: 32"
    rendered.should contain "Effective: 3498"

    rendered.should contain "Wisdom:"
    rendered.should contain "Base: 20"
    rendered.should contain "Effective: 272"

    rendered.should contain "Run Speed: 50.0"
    rendered.should contain "Personal Status: 29560875"
  end

  it "should show offensive skills" do
    render

    rendered.should contain "Accuracy: 38.799999"
    rendered.should contain "AE Auto Attack: 20.0"
    rendered.should contain "Attack Speed: 184.967194"
    rendered.should contain "Potency: 200.999985"
    rendered.should contain "Critical Bonus: 222.648361"
    rendered.should contain "Critical Chance: 293.699982"
    rendered.should contain "Double Attack: 603.419922"
    rendered.should contain "DPS: 108.899971"
    rendered.should contain "Flurry: 15.0"
    rendered.should contain "Hate Gain Mod: 0.0"
    rendered.should contain "Strikethrough: 100.0"
  end

  it "should show defensive skills" do
    render

    rendered.should contain "Base Avoidance Bonus: 2.4"
    rendered.should contain "Block Chance: 60.099995"
    rendered.should contain "Armour: 150"
    rendered.should contain "Avoidance: 19044"
    rendered.should contain "Block: 600"
    rendered.should contain "Parry: 236"
  end

  it "should show casting skills" do
    render

    rendered.should contain "Ability Modifier: 1160.800049"
    rendered.should contain "Spell Double Attack: 0.0"
    rendered.should contain "Spell Time Cast %: 16.90592"
    rendered.should contain "Spell Time Recovery %: 0.0"
    rendered.should contain "Spell Time Reuse %: 32.300003"
    rendered.should contain "Spell Time Reuse Spell Only: 0.0"
  end

  it "should show melee weapon skills" do
    render

    rendered.should contain "Primary:"
    rendered.should contain "Damage: 1039 - 5204"
    rendered.should contain "Delay: 2.983852"

    rendered.should contain "Secondary:"
    rendered.should contain "Damage: 926 - 4638"
    rendered.should contain "Delay: 2.983852"

    rendered.should contain "Ranged:"
    rendered.should contain "Damage: 2923 - 13776"
    rendered.should contain "Delay: 4.0282"
  end

  it "should show spell weapon skills" do
    render

    rendered.should contain "Auto Attack Chance: 0.0"
    rendered.should contain "Attack Speed: 0.0"
    rendered.should contain "Double Attack: 0.0"
    rendered.should contain "DPS: 0.0"
    rendered.should contain "Flurry: 0.0"
  end

  it "should show savagery skills" do
    render

    rendered.should contain "In Combat Regen: 0.0"
    rendered.should contain "Max Level: 0.0"
    rendered.should contain "Out Of Combat Regen: 0.0"
    rendered.should contain "Gain Mod: 0.0"
    rendered.should contain "Base Regen: 0.0"
  end

  it "should show pvp skills" do
    render

    rendered.should contain "Double Attack Chance: 62.519989"
    rendered.should contain "Spell Double Attack Chance: 0.0"
    rendered.should contain "Toughness: 0"
  end

  it "should show trade skills" do
    render

    rendered.should contain "Critical Chance:"
    rendered.should contain "Failure Modifier: 0.0"
    rendered.should contain "Success Modifier: 1.0"

    rendered.should contain "Durability:"
    rendered.should contain "Added: 0.0"
    rendered.should contain "Modifier: 0.0"

    rendered.should contain "Progress:"
    rendered.should contain "Added: 0.0"
    rendered.should contain "Modifier: 2.0"

    rendered.should contain "Rare Harvest Chance: 0.0"
    rendered.should contain "Success Modifier: 3.0"
  end
end