require 'test_helper'

class SpritesControllerTest < ActionController::TestCase
  setup do
    @sprite = sprites(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sprites)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sprite" do
    assert_difference('Sprite.count') do
      post :create, :sprite => { :file => @sprite.file, :name => @sprite.name }
    end

    assert_redirected_to sprite_path(assigns(:sprite))
  end

  test "should show sprite" do
    get :show, :id => @sprite
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @sprite
    assert_response :success
  end

  test "should update sprite" do
    put :update, :id => @sprite, :sprite => { :file => @sprite.file, :name => @sprite.name }
    assert_redirected_to sprite_path(assigns(:sprite))
  end

  test "should destroy sprite" do
    assert_difference('Sprite.count', -1) do
      delete :destroy, :id => @sprite
    end

    assert_redirected_to sprites_path
  end
end
