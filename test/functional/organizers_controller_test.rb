require 'test_helper'

class OrganizersControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Organizer.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Organizer.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Organizer.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to organizer_url(assigns(:organizer))
  end
  
  def test_edit
    get :edit, :id => Organizer.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Organizer.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Organizer.first
    assert_template 'edit'
  end

  def test_update_valid
    Organizer.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Organizer.first
    assert_redirected_to organizer_url(assigns(:organizer))
  end
  
  def test_destroy
    organizer = Organizer.first
    delete :destroy, :id => organizer
    assert_redirected_to organizers_url
    assert !Organizer.exists?(organizer.id)
  end
end
