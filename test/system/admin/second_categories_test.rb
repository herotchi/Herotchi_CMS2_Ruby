require "application_system_test_case"

class Admin::SecondCategoriesTest < ApplicationSystemTestCase
  setup do
    @second_category = second_categories(:one)
  end

  test "visiting the index" do
    visit second_categories_url
    assert_selector "h1", text: "Second categories"
  end

  test "should create second category" do
    visit second_categories_url
    click_on "New second category"

    fill_in "First categori", with: @second_category.first_categori_id
    fill_in "Name", with: @second_category.name
    click_on "Create Second category"

    assert_text "Second category was successfully created"
    click_on "Back"
  end

  test "should update Second category" do
    visit second_category_url(@second_category)
    click_on "Edit this second category", match: :first

    fill_in "First categori", with: @second_category.first_categori_id
    fill_in "Name", with: @second_category.name
    click_on "Update Second category"

    assert_text "Second category was successfully updated"
    click_on "Back"
  end

  test "should destroy Second category" do
    visit second_category_url(@second_category)
    click_on "Destroy this second category", match: :first

    assert_text "Second category was successfully destroyed"
  end
end
