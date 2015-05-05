require 'test_helper'

class LayoutPatternsControllerTest < ActionController::TestCase
  setup do
    @layout_pattern = layout_patterns(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:layout_patterns)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create layout_pattern" do
    assert_difference('LayoutPattern.count') do
      post :create, layout_pattern: { name: @layout_pattern.name, note: @layout_pattern.note }
    end

    assert_redirected_to layout_pattern_path(assigns(:layout_pattern))
  end

  test "should show layout_pattern" do
    get :show, id: @layout_pattern
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @layout_pattern
    assert_response :success
  end

  test "should update layout_pattern" do
    patch :update, id: @layout_pattern, layout_pattern: { name: @layout_pattern.name, note: @layout_pattern.note }
    assert_redirected_to layout_pattern_path(assigns(:layout_pattern))
  end

  test "should destroy layout_pattern" do
    assert_difference('LayoutPattern.count', -1) do
      delete :destroy, id: @layout_pattern
    end

    assert_redirected_to layout_patterns_path
  end
end
