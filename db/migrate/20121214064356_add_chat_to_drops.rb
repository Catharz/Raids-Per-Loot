class AddChatToDrops < ActiveRecord::Migration
  def change
    add_column :drops, :chat, :text
  end
end
