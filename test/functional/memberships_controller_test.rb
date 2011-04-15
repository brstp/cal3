require 'test_helper'

class MembershipsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Membership.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Membership.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Membership.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to membership_url(assigns(:membership))
  end

  def test_edit
    get :edit, :id => Membership.first
    assert_template 'edit'
  end

  def test_update_invalid
    Membership.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Membership.first
    assert_template 'edit'
  end

  def test_update_valid
    Membership.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Membership.first
    assert_redirected_to membership_url(assigns(:membership))
  end

  def test_destroy
    membership = Membership.first
    delete :destroy, :id => membership
    assert_redirected_to memberships_url
    assert !Membership.exists?(membership.id)
  end
end
