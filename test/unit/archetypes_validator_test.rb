require 'test_helper'
require 'archetypes_validator'

class ArchetypesValidatorTest < ActiveSupport::TestCase
  def setup
    @validator = ArchetypesValidator.new({})
  end

  def test_valid_archetype
    archetype = create_archetype(:name => 'Valid')
    @validator.validate(archetype)
    assert_empty archetype.errors
  end

  def test_archetype_cannot_be_own_parent
    parent_archetype = create_archetype(:name => 'Parent')
    archetype = create_archetype(:name => 'Parent', :parent =>  parent_archetype)
    assert  @validator.is_own_parent?(archetype)
  end

  def test_archetype_cannot_be_own_descendant
    grand_parent = create_archetype(:name => 'Grand Parent')
    parent = create_archetype(:name => 'Parent')
    grand_parent.children << parent
    child = create_archetype(:name => 'Child')
    parent.children << child
    assert  @validator.is_own_descendant?(grand_parent), "Grand parent should have been detected as being a descendant"
    assert  @validator.is_own_descendant?(parent), "Parent should have been detected as being a descendant"
  end

protected
  def create_archetype(options = {})
    Archetype.new({:name => 'Test'}.merge(options))
  end
end