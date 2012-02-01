require File.dirname(__FILE__) + '/../test_helper'
require 'archetypes_controller'

# Re-raise errors caught by the controller.
class ArchetypesController; def rescue_action(e) raise e end; end

class ArchetypesControllerTest < ActionController::TestCase
  def test_should_create_archetype
    assert_difference 'Archetype.count' do
      create_archetype
      assert_response :redirect
    end
  end

  def test_archetype_cannot_be_own_parent
    create_archetype :name => 'Parent'
    assert_no_difference 'Archetype.count' do
      create_archetype :name => 'Parent', :parent => Archetype.find_by_name('Parent')
      assert_response :ok
      assert response.body.include? "Cannot set an archetypes parent to itself"
    end
  end

  def test_parent_archetype_cannot_be_own_child
    create_archetype :name => 'Grand Parent'
    create_archetype :name => 'Parent', :parent_id => Archetype.find_by_name('Grand Parent').id
    create_archetype :name => 'Child', :parent_id => Archetype.find_by_name('Parent').id
    assert_no_difference 'Archetype.count' do
      grand_parent = Archetype.find_by_name('Grand Parent')
      child = Archetype.find_by_name('Child')
      edit_archetype grand_parent, :parent_id => child.id
      assert_response :ok
      assert response.body.include? "Cannot set an archetypes parent to one of its descendents"
    end
  end

  protected
    def edit_archetype(archetype, options = {})
      post :update, :id => archetype.id, :archetype => archetype.attributes.merge(options)
    end

    def create_archetype(options = {})
      post :create, :archetype => { :name => 'Test' }.merge(options)
    end
end