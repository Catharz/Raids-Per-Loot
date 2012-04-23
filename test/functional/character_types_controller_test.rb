require 'test_helper'

class CharacterTypesControllerTest < ActionController::TestCase
  fixtures :users

  setup do
    login_as :quentin
    archetype = Factory.create(:archetype, :name => 'Mage')
    betty = Factory.create(:character, :name => 'Betty', :archetype_id => archetype.id)
    @character_type = Factory.create(:character_type,
                                 :character => betty,
                                 :effective_date => Date.new,
                                 :char_type => 'm')
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:character_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create character_type" do
    assert_difference('CharacterType.count') do
      post :create, character_type: @character_type.attributes
    end

    assert_redirected_to character_type_path(assigns(:character_type))
  end

  test "should show character_type" do
    get :show, id: @character_type.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @character_type.to_param
    assert_response :success
  end

  test "should update character_type" do
    put :update, id: @character_type.to_param, character_type: @character_type.attributes
    assert_redirected_to character_type_path(assigns(:character_type))
  end

  test "should destroy character_type" do
    assert_difference('CharacterType.count', -1) do
      delete :destroy, id: @character_type.to_param
    end

    assert_redirected_to character_types_path
  end
end