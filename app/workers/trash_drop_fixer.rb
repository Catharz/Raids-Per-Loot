class TrashDropFixer
  @queue = :trash_drop_fixer

  def self.perform
    Item.of_type('Trash').includes(:drops).where('drops.loot_method <> ?', 't').each do |item|
      item.drops.where('loot_method <> ?', 't').each do |drop|
        drop.update_attribute(:loot_method, 't')
      end
    end
  end
end