class AddDefaultSlots < ActiveRecord::Migration
  @slots = ['Head', 'Chest', 'Shoulders', 'Forearms', 'Legs', 'Hands', 'Feet',
                'Neck', 'Ear', 'Finger', 'Wrist', 'Charm', 'Ranged', 'Primary', 'Secondary']

  def self.up
    @slots.each do |slot|
      if !Slot.find_by_name(slot)
        Slot.create(:name => slot)
      end
    end
  end

  def self.down
    @slots.each do |slot|
      Slot.find_by_name!(slot).delete
    end
  end
end
