class ItemDetailsJob < Struct.new(:item)
  def perform
    item.fetch_soe_item_details unless item.nil?
  end
end