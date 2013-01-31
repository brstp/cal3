require 'test_helper'

class SyndicationsControllerTest < ActionController::TestCase
  setup do
    @syndication = syndications(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:syndications)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create syndication" do
    assert_difference('Syndication.count') do
      post :create, syndication: { organizer_id: @syndication.organizer_id, syndicated_organizer_id: @syndication.syndicated_organizer_id }
    end

    assert_redirected_to syndication_path(assigns(:syndication))
  end

  test "should show syndication" do
    get :show, id: @syndication
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @syndication
    assert_response :success
  end

  test "should update syndication" do
    put :update, id: @syndication, syndication: { organizer_id: @syndication.organizer_id, syndicated_organizer_id: @syndication.syndicated_organizer_id }
    assert_redirected_to syndication_path(assigns(:syndication))
  end

  test "should destroy syndication" do
    assert_difference('Syndication.count', -1) do
      delete :destroy, id: @syndication
    end

    assert_redirected_to syndications_path
  end
end
