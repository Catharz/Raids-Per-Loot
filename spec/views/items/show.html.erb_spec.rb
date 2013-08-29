require 'spec_helper'

describe 'items/show.html.erb' do
  before(:each) do
    weapon = stub_model(LootType, :name => 'Weapon')
    @item = assign(:item, stub_model(Item,
                                     :name => 'Name',
                                     :eq2_item_id => 'Eq2 Item',
                                     :info_url => 'Info Url',
                                     :loot_type => weapon
    ))
  end

  it 'renders headings' do
    render

    rendered.should contain('Image')
    rendered.should contain('Details')
    rendered.should contain('Classes')
    rendered.should contain('Slots')
    rendered.should contain('Drops')
    rendered.should contain('Data')
  end

  it 'renders the items details' do
    render

    rendered.should contain('Name: Name')
    rendered.should contain('EQ2 Item Id: Eq2 Item')
    rendered.should contain('Info url: Info Url')
    rendered.should contain('Item Type: Weapon')
  end

  it 'renders a list of archetypes that can use it' do
    monk = stub_model(Archetype, :name => 'Monk')
    @item.archetypes << monk
    monk.items << @item

    render

    rendered.should contain('Classes:')
    rendered.should contain('Monk')
  end

  it 'renders a list of slots it can be equipped in' do
    wrist = stub_model(Slot, :name => 'Wrist')
    @item.slots << wrist
    wrist.items << @item

    render

    rendered.should contain('Slots:')
    rendered.should contain('Wrist')
  end
end
