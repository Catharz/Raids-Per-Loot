require 'spec_helper'

describe 'characters/index.html.haml' do
  it 'renders all tabs' do
    render

    assert_select 'div#tabBook ul li a', text: 'Raid Mains'
    assert_select 'div#tabBook ul li a', text: 'Raid Alts'
    assert_select 'div#tabBook ul li a', text: 'General Alts'
    assert_select 'div#tabBook ul li a', text: 'All'
  end

  it 'renders headings for each table' do
    render

    assert_select 'table tr th', text: 'Name', count: 4
    assert_select 'table tr th', text: 'Main', count: 4
    assert_select 'table tr th', text: 'Player', count: 4
    assert_select 'table tr th', text: 'Class', count: 4
    assert_select 'table tr th', text: 'First Raid', count: 4
    assert_select 'table tr th', text: 'Last Raid', count: 4
    assert_select 'table tr th', text: 'Raids', count: 4
    assert_select 'table tr th', text: 'Instances', count: 4
    assert_select 'table tr th', text: 'Armour Rate', count: 4
    assert_select 'table tr th', text: 'Jewellery Rate', count: 4
    assert_select 'table tr th', text: 'Weapon Rate', count: 4
  end
end