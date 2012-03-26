require 'test_helper'

class DifficultiesControllerTest < ActionController::TestCase
  setup do
    @difficulty = Factory.create(:difficulty, :name => 'High')
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:difficulties)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create difficulty" do
    assert_difference('Difficulty.count') do
      post :create, difficulty: @difficulty.attributes
    end

    assert_redirected_to difficulty_path(assigns(:difficulty))
  end

  test "should show difficulty" do
    get :show, id: @difficulty.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @difficulty.to_param
    assert_response :success
  end

  test "should update difficulty" do
    put :update, id: @difficulty.to_param, difficulty: @difficulty.attributes
    assert_redirected_to difficulty_path(assigns(:difficulty))
  end

  test "should destroy difficulty" do
    assert_difference('Difficulty.count', -1) do
      delete :destroy, id: @difficulty.to_param
    end

    assert_redirected_to difficulties_path
  end
end
