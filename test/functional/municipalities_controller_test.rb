#require 'test_helper'

class MunicipalitiesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Municipality.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Municipality.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Municipality.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to municipality_url(assigns(:municipality))
  end
  
  def test_edit
    get :edit, :id => Municipality.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Municipality.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Municipality.first
    assert_template 'edit'
  end

  def test_update_valid
    Municipality.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Municipality.first
    assert_redirected_to municipality_url(assigns(:municipality))
  end
  
  def test_destroy
    municipality = Municipality.first
    delete :destroy, :id => municipality
    assert_redirected_to municipalities_url
    assert !Municipality.exists?(municipality.id)
  end


end
