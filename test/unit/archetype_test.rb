require 'test_helper'

class ArchetypeTest < ActiveSupport::TestCase
  def setup
    @top = create_archetype :name => 'Top'
    @middle = create_archetype :name => 'Middle'
    @top.children << @middle
    @bottom = create_archetype :name => 'Bottom'
    @middle.children << @bottom
  end

  def test_descendants_should_include_all_children
    descendants = Archetype.descendants(@top)
    assert_include descendants, @middle
    assert_include descendants, @bottom
  end

  def test_descendants_should_not_include_root
    descendants = Archetype.descendants(@top)
    assert_not_include descendants, @top
  end

  def test_family_should_include_root
    descendants = Archetype.family(@top)
    assert_include descendants, @top
  end

  protected
  def create_archetype(options = {})
    Archetype.new({:name => 'Test'}.merge(options))
  end
end