class CreateCharacterTypes < ActiveRecord::Migration
  def change
    create_table :character_types do |t|
      t.belongs_to(:character)
      t.date :effective_date
      t.string :char_type, :length => 1

      t.timestamps
    end
  end
end
