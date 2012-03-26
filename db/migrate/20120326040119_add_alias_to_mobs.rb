class AddAliasToMobs < ActiveRecord::Migration
  def change
    add_column :mobs, :alias, :string
  end
end
