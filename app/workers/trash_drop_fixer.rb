# @author Craig Read
#
# TrashDropFixer manages updating the loot method of
# drops of items of type 'Trash' to an appropriate value
class TrashDropFixer
  @queue = :trash_drop_fixer

  def self.perform
    Drop.paper_trail_off
    Item.of_type('Trash').includes(:drops).where('drops.loot_method <> ?', 't').each do |item|
      item.drops.where('loot_method <> ?', 't').each do |drop|
        drop.update_attribute(:loot_method, 't')
      end
    end
    Drop.paper_trail_on
  end
end