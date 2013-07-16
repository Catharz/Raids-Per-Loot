class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.date :comment_date
      t.integer :commented_id
      t.string :commented_type
      t.text :comment

      t.timestamps
    end
  end
end
