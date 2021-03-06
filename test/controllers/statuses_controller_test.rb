require 'test_helper'

class StatusesControllerTest < ActionController::TestCase
  setup do
    @status = statuses(:one)
  end

  test "can get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:statuses)
  end

  test "can show status" do
    get :show, id: @status
    assert_response :success
  end

  test "can not see new status page unless signed in" do
    get :new
    assert_response :redirect
    assert_redirected_to new_user_session_path
    end

  test "can see new status page if signed in" do
    sign_in users(:chris)
    get :new
    assert_response :success
  end

  test "can not create status unless signed in" do
    assert_no_difference ('Status.count') do
      post :create, status: { content: @status.content }
    end
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "can create status if signed in" do
    sign_in users(:chris)
    assert_difference('Status.count', +1) do
      post :create, status: { content: @status.content }
    end
    assert_response :redirect
    assert_redirected_to statuses_url
  end

  test "can create status only for signed in user" do
    sign_in users(:chris)
    assert_difference('Status.count', +1) do
      post :create, status: { content: @status.content , user_id: users(:nyk).id}
    end
    assert_response :redirect
    assert_redirected_to statuses_url
    assert_equal assigns(:status).user_id, users(:chris).id

  end

  ##Update

  test "can not edit status unless signed in" do
    get :edit, id: @status
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "can edit status if signed in" do
    sign_in users(:chris)
    get :edit, id: @status
    assert_response :success
  end

  test "can not update status unless signed in" do
    patch :update, id: @status, status: { content: @status.content}
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "can update status if signed in" do
    sign_in users(:chris)
    patch :update, id: @status, status: { content: @status.content}
    assert_redirected_to status_path(assigns(:status))
  end

  test "can update status only for signed in user" do
    sign_in users(:chris)
    patch :update, id: @status, status: { content: @status.content, user_id: users(:nyk).id }
    assert_redirected_to status_path(assigns(:status))
  end

  ##Destroy

  test "can not destroy status unless signed in" do
    assert_no_difference('Status.count', -1) do
      delete :destroy, id: @status
    end
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "can destroy status if signed in" do
    sign_in users(:chris)
    assert_difference('Status.count', -1) do
      delete :destroy, id: @status
    end
    assert_redirected_to statuses_path
  end

end

