require "application_system_test_case"

class Admin::FirstCategoriesTest < ApplicationSystemTestCase
  setup do
    @first_category = first_categories(:one)
  end

  test "visiting the index" do
    visit first_categories_url
    assert_selector "h1", text: "First categories"
  end

  test "should create first category" do
    visit first_categories_url
    click_on "New first category"

    fill_in "Name", with: @first_category.name
    click_on "Create First category"

    assert_text "First category was successfully created"
    click_on "Back"
  end

  test "should update First category" do
    visit first_category_url(@first_category)
    click_on "Edit this first category", match: :first

    fill_in "Name", with: @first_category.name
    click_on "Update First category"

    assert_text "First category was successfully updated"
    click_on "Back"
  end

  test "should destroy First category" do
    visit first_category_url(@first_category)
    click_on "Destroy this first category", match: :first

    assert_text "First category was successfully destroyed"
  end
end
