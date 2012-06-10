require 'test_helper'

# Re-raise errors caught by the controller.
class ArchetypesController; def rescue_action(e) raise e end; end

class ArchetypesControllerTest < ActionController::TestCase
  fixtures :users

  def setup
    login_as :quentin
  end

  test "should create archetype" do
    assert_difference('Archetype.count') do
      post :create, :archetype => {:name => 'Blah'}
    end

    assert_redirected_to archetype_path(assigns(:archetype))
  end

  test "archetype cannot be own parent" do
    parent = FactoryGirl.create(:archetype, :name => 'Parent')
    assert_no_difference('Archetype.count') do
      edit_archetype parent, :parent_id => parent.id
      assert_response :ok
      assert response.body.include? "Cannot set an archetypes parent to itself"
    end
  end

  test "parent archetype cannot be own child" do
    grand_parent = FactoryGirl.create(:archetype, :name => 'Grand Parent')
    parent = FactoryGirl.create(:archetype, :name => 'Parent', :parent => grand_parent)
    child = FactoryGirl.create(:archetype, :name => 'Child', :parent => parent)

    assert_no_difference 'Archetype.count' do
      edit_archetype grand_parent, :parent_id => child.id
      assert_response :ok
      assert response.body.include? "Cannot set an archetypes parent to one of its descendants"
    end
  end

  protected
    def edit_archetype(archetype, options = {})
      post :update, :id => archetype.id, :archetype => archetype.attributes.merge(options)
    end

    def create_archetype(options = {})
      archetype = FactoryGirl.create(:archetype, options)
      post :create, :archetype => archetype
    end
end