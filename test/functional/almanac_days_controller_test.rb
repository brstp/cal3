require 'test_helper'

class AlmanacDaysControllerTest < ActionController::TestCase
  setup do
    @almanac_day = almanac_days(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:almanac_days)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create almanac_day" do
    assert_difference('AlmanacDay.count') do
      post :create, almanac_day: @almanac_day.attributes
    end

    assert_redirected_to almanac_day_path(assigns(:almanac_day))
  end

  test "should show almanac_day" do
    get :show, id: @almanac_day.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @almanac_day.to_param
    assert_response :success
  end

  test "should update almanac_day" do
    put :update, id: @almanac_day.to_param, almanac_day: @almanac_day.attributes
    assert_redirected_to almanac_day_path(assigns(:almanac_day))
  end

  test "should destroy almanac_day" do
    assert_difference('AlmanacDay.count', -1) do
      delete :destroy, id: @almanac_day.to_param
    end

    assert_redirected_to almanac_days_path
  end
end
