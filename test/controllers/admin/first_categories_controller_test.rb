require "test_helper"

class Admin::FirstCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @first_category = first_categories(:one)
  end

  test "should get index" do
    get admin_first_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_first_category_url
    assert_response :success
  end

  test "should create first_category" do
    assert_difference("FirstCategory.count") do
      post admin_first_categories_url, params: { first_category: { name: @first_category.name } }
    end

    assert_redirected_to admin_first_category_url(FirstCategory.last)
  end

  test "should show first_category" do
    get admin_first_category_url(@first_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_first_category_url(@first_category)
    assert_response :success
  end

  test "should update first_category" do
    patch admin_first_category_url(@first_category), params: { first_category: { name: @first_category.name } }
    assert_redirected_to admin_first_category_url(@first_category)
  end

  test "should destroy first_category" do
    assert_difference("FirstCategory.count", -1) do
      delete admin_first_category_url(@first_category)
    end

    assert_redirected_to admin_first_categories_url
  end
end
