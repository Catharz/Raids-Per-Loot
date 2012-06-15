class AddExternalData < ActiveRecord::Migration
  def up
    create_table :external_data, :force => true do |t|
      t.integer :retrievable_id
      t.string :retrievable_type
      t.text :data
    end
  end

  def down
    drop_table :external_data
  end
end
