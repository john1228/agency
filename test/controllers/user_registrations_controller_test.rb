require 'test_helper'

class UserRegistrationsControllerTest < ActionController::TestCase
  setup do
    @user_registration = user_registrations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_registrations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_registration" do
    assert_difference('UserRegistration.count') do
      post :create, user_registration: { address: @user_registration.address, avatar: @user_registration.avatar, birthday: @user_registration.birthday, client_id: @user_registration.client_id, gender: @user_registration.gender, mobile: @user_registration.mobile, name: @user_registration.name, reg_type: @user_registration.reg_type, remark: @user_registration.remark, service_id: @user_registration.service_id, source: @user_registration.source }
    end

    assert_redirected_to user_registration_path(assigns(:user_registration))
  end

  test "should show user_registration" do
    get :show, id: @user_registration
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_registration
    assert_response :success
  end

  test "should update user_registration" do
    patch :update, id: @user_registration, user_registration: { address: @user_registration.address, avatar: @user_registration.avatar, birthday: @user_registration.birthday, client_id: @user_registration.client_id, gender: @user_registration.gender, mobile: @user_registration.mobile, name: @user_registration.name, reg_type: @user_registration.reg_type, remark: @user_registration.remark, service_id: @user_registration.service_id, source: @user_registration.source }
    assert_redirected_to user_registration_path(assigns(:user_registration))
  end

  test "should destroy user_registration" do
    assert_difference('UserRegistration.count', -1) do
      delete :destroy, id: @user_registration
    end

    assert_redirected_to user_registrations_path
  end
end
