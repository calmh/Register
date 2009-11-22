require 'test_helper'

class ClubsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:clubs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create club" do
    assert_difference('Club.count') do
      post :create, :club => { :name => "Test club" }
    end

    assert_redirected_to club_path(assigns(:club))
  end

  test "should show club" do
    get :show, :id => clubs(:one).id
    assert_response :success
    assert assigns(:club)
    club = assigns(:club)
    assert club.students.length == 2
  end

  test "should get edit" do
    get :edit, :id => clubs(:one).id
    assert_response :success
  end

  test "should update club" do
    put :update, :id => clubs(:one).id, :club => { }
    assert_redirected_to club_path(assigns(:club))
  end

  test "should destroy club" do
    assert_difference('Club.count', -1) do
      delete :destroy, :id => clubs(:one).id
    end

    assert_redirected_to clubs_path
  end
end
