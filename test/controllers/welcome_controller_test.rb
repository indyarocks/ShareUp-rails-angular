require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  setup do 
    @user = users(:one)
  end

  test "it should show index page" do 
    get 'index'
    assert :success
  end

  test "it should show dashboard page" do
    sign_in @user
    get 'dashboard'
    assert_template :dashboard
    assert_template layout: 'layouts/angular'
  end

  test "should redirect to login page for non logged in user" do
    get :dashboard
    assert :redirect
  end

end
