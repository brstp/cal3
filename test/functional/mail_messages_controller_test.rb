require 'test_helper'

class MailMessagesControllerTest < ActionController::TestCase
  setup do
    @mail_message = mail_messages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mail_messages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mail_message" do
    assert_difference('MailMessage.count') do
      post :create, :mail_message => @mail_message.attributes
    end

    assert_redirected_to mail_message_path(assigns(:mail_message))
  end

  test "should show mail_message" do
    get :show, :id => @mail_message.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @mail_message.to_param
    assert_response :success
  end

  test "should update mail_message" do
    put :update, :id => @mail_message.to_param, :mail_message => @mail_message.attributes
    assert_redirected_to mail_message_path(assigns(:mail_message))
  end

  test "should destroy mail_message" do
    assert_difference('MailMessage.count', -1) do
      delete :destroy, :id => @mail_message.to_param
    end

    assert_redirected_to mail_messages_path
  end
end
