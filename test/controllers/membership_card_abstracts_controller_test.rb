require 'test_helper'

class MembershipCardAbstractsControllerTest < ActionController::TestCase
  setup do
    @membership_card_abstract = membership_card_abstracts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:membership_card_abstracts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create membership_card_abstract" do
    assert_difference('MembershipCardAbstract.count') do
      post :create, membership_card_abstract: { card_type: @membership_card_abstract.card_type, client_id: @membership_card_abstract.client_id, count: @membership_card_abstract.count, days: @membership_card_abstract.days, has_valid_extend_information: @membership_card_abstract.has_valid_extend_information, latest_delay_days: @membership_card_abstract.latest_delay_days, name: @membership_card_abstract.name, price: @membership_card_abstract.price, service_id: @membership_card_abstract.service_id, valid_days: @membership_card_abstract.valid_days }
    end

    assert_redirected_to membership_card_abstract_path(assigns(:membership_card_abstract))
  end

  test "should show membership_card_abstract" do
    get :show, id: @membership_card_abstract
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @membership_card_abstract
    assert_response :success
  end

  test "should update membership_card_abstract" do
    patch :update, id: @membership_card_abstract, membership_card_abstract: { card_type: @membership_card_abstract.card_type, client_id: @membership_card_abstract.client_id, count: @membership_card_abstract.count, days: @membership_card_abstract.days, has_valid_extend_information: @membership_card_abstract.has_valid_extend_information, latest_delay_days: @membership_card_abstract.latest_delay_days, name: @membership_card_abstract.name, price: @membership_card_abstract.price, service_id: @membership_card_abstract.service_id, valid_days: @membership_card_abstract.valid_days }
    assert_redirected_to membership_card_abstract_path(assigns(:membership_card_abstract))
  end

  test "should destroy membership_card_abstract" do
    assert_difference('MembershipCardAbstract.count', -1) do
      delete :destroy, id: @membership_card_abstract
    end

    assert_redirected_to membership_card_abstracts_path
  end
end
