class AddConfirmedRatingToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :confirmed_rating, :string, limit: 20
    add_column :characters, :confirmed_date, :date
  end
end
