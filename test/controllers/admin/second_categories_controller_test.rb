require "test_helper"

class Admin::SecondCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @second_category = second_categories(:one)
  end

  test "should get index" do
    get admin_second_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_second_category_url
    assert_response :success
  end

  test "should create second_category" do
    assert_difference("SecondCategory.count") do
      post admin_second_categories_url, params: { second_category: { first_categori_id: @second_category.first_categori_id, name: @second_category.name } }
    end

    assert_redirected_to admin_second_category_url(SecondCategory.last)
  end

  test "should show second_category" do
    get admin_second_category_url(@second_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_second_category_url(@second_category)
    assert_response :success
  end

  test "should update second_category" do
    patch admin_second_category_url(@second_category), params: { second_category: { first_categori_id: @second_category.first_categori_id, name: @second_category.name } }
    assert_redirected_to admin_second_category_url(@second_category)
  end

  test "should destroy second_category" do
    assert_difference("SecondCategory.count", -1) do
      delete admin_second_category_url(@second_category)
    end

    assert_redirected_to admin_second_categories_url
  end
end
