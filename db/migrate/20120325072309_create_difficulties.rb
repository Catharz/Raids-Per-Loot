class CreateDifficulties < ActiveRecord::Migration
  def change
    create_table :difficulties do |t|
      t.string :name
      t.integer :rating

      t.timestamps
    end
  end
end
