require 'test_helper'

class PetitionsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Petition.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Petition.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Petition.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to petition_url(assigns(:petition))
  end

  def test_edit
    get :edit, :id => Petition.first
    assert_template 'edit'
  end

  def test_update_invalid
    Petition.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Petition.first
    assert_template 'edit'
  end

  def test_update_valid
    Petition.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Petition.first
    assert_redirected_to petition_url(assigns(:petition))
  end

  def test_destroy
    petition = Petition.first
    delete :destroy, :id => petition
    assert_redirected_to petitions_url
    assert !Petition.exists?(petition.id)
  end
end
