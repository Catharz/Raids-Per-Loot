require 'spec_helper'
require 'attendance_spec_helper'
require 'drop_spec_helper'
require 'character_spec_helper'

describe DropObserver do
  include AttendanceSpecHelper, DropSpecHelper, CharacterSpecHelper

  describe 'saving a drop' do
    before do
      @character = Character.create(valid_character_attributes(:name => "Looter 2", :char_type => 'm'))
      @obs = DropObserver.instance
    end

    it "should update the characters armour rate" do
      character_list = setup_characters(%w{Scout Mage})
      character = character_list[0]
      create_attendance(:num_raids => 2, :num_instances => 3, :attendees => character_list)
      expect {
        drop = add_drop(character, "Armour")
        @obs.after_save(drop)
      }.to change {
        character.armour_rate
      }.by(1)
    end

    it "should update the characters jewellery rate" do
      character_list = setup_characters(%w{Scout Mage})
      character = character_list[0]
      create_attendance(:num_raids => 3, :num_instances => 3, :attendees => character_list)
      expect {
        drop = add_drop(character, "Jewellery")
        @obs.after_save(drop)
      }.to change {
        character.jewellery_rate
      }.by(1.5)
    end

    it "should update the characters weapon rate" do
      character_list = setup_characters(%w{Scout Mage})
      character = character_list[0]
      create_attendance(:num_raids => 4, :num_instances => 3, :attendees => character_list)
      expect {
        drop = add_drop(character, "Weapon")
        @obs.after_save(drop)
      }.to change {
        character.weapon_rate
      }.by(2.0)
    end
  end
end