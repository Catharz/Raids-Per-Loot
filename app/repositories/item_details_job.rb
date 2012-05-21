class ItemDetailsJob < Struct.new(:item_name)
  def perform
    if item_name
      item = Item.find_by_name(item_name)
      item.fetch_soe_item_details unless item.nil?
    end
  end
end