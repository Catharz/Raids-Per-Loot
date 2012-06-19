require 'test_helper'

class CharacterTypesControllerTest < ActionController::TestCase
  fixtures :users

  def setup
    login_as :quentin

    archetype = FactoryGirl.create(:archetype, :name => 'Mage')
    rank = FactoryGirl.create(:rank, :name => 'Main')
    @player = FactoryGirl.create(:player, :name => 'Dino', :rank_id => rank.id)
    betty = FactoryGirl.create(:character, :name => 'Betty', :archetype_id => archetype.id, :player_id => @player.id)
    @character_type = FactoryGirl.create(:character_type,
                                         :character => betty,
                                         :effective_date => Date.parse("01/02/2012"),
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