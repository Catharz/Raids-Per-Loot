class CreateCharacters < ActiveRecord::Migration
  # Create Characters
  # Copy non-main players to characters
  # Create characters - instances relationship
  # Create characters - drops relationship
  # Remove the non-main players
  # Add a "CharacterType" to characters
  # Remove the archetype from Players
  # Remove the main_character_id from Players
  def change
    create_table :characters do |t|
      t.string :name
      t.belongs_to(:player)
      t.belongs_to(:archetype)
      t.belongs_to(:rank)

      t.timestamps
    end
  end
end
