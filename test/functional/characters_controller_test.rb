require 'test_helper'

class CharactersControllerTest < ActionController::TestCase
  fixtures :users

  def setup
    login_as :quentin

    rank = FactoryGirl.create(:rank, :name => 'Main')
    @player = FactoryGirl.create(:player, :name => 'Dino', :rank_id => rank.id)
    archetype = FactoryGirl.create(:archetype, :name => 'Mage')
    @character = FactoryGirl.create(:character,
                                    :player_id => @player.id,
                                    :name => 'Betty',
                                    :archetype_id => archetype.id,
                                    :char_type => 'm',
                                    :external_data => nil)
    FactoryGirl.create(:character_type,
                       :character => @character,
                       :effective_date => Date.parse("01/01/2012"),
                       :char_type => 'm')
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:characters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create character" do
    assert_difference('Character.count') do
      post :create, :character => {:name => "New Character", :char_type => "g", :player_id => @player.id}
    end

    assert_redirected_to character_path(assigns(:character))
  end

  test "should create character type for new character" do
    assert_difference('CharacterType.count') do
      post :create, :character => {:name => "New Character", :char_type => "g", :player_id => @player.id}
    end

    assert_redirected_to character_path(assigns(:character))
  end

  test "it should require a character type" do
    assert_no_difference('Character.count') do
      post :create, :character => {:name => "New Character"}
    end

    assert_response :success
  end

  test "it should not require a player on create" do
    assert_difference('Character.count') do
      post :create, :character => {:name => "New Character", :char_type => "g"}
    end

    assert_response :redirect
  end

  test "should show character" do
    get :show, id: @character.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @character.to_param
    assert_response :success
  end

  test "should update character" do
    put :update, id: @character.to_param, character: @character.attributes
    assert_redirected_to character_path(assigns(:character))
  end

  #TODO: Need a better test than this, and move it into rspec
  test "should require a player when editing a character" do
    @character.player_id = nil
    put :update, id: @character.to_param, character: @character.attributes
    assert_response :success
  end

  test "should create character type for updated character" do
    assert_difference('CharacterType.count') do
      put :update, id: @character.to_param, character: @character.attributes.merge({:char_type => 'r'})
    end

    assert_redirected_to character_path(assigns(:character))
  end

  test "should destroy character" do
    assert_difference('Character.count', -1) do
      delete :destroy, id: @character.to_param
    end

    assert_redirected_to characters_path
  end
end
