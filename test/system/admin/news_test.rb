require "application_system_test_case"

class Admin::NewsTest < ApplicationSystemTestCase
  setup do
    @news = news(:one)
  end

  test "visiting the index" do
    visit news_url
    assert_selector "h1", text: "News"
  end

  test "should create news" do
    visit news_url
    click_on "New news"

    check "Link flg" if @news.link_flg
    fill_in "Overview", with: @news.overview
    fill_in "Release date", with: @news.release_date
    check "Release flg" if @news.release_flg
    fill_in "Title", with: @news.title
    fill_in "Url", with: @news.url
    click_on "Create News"

    assert_text "News was successfully created"
    click_on "Back"
  end

  test "should update News" do
    visit news_url(@news)
    click_on "Edit this news", match: :first

    check "Link flg" if @news.link_flg
    fill_in "Overview", with: @news.overview
    fill_in "Release date", with: @news.release_date
    check "Release flg" if @news.release_flg
    fill_in "Title", with: @news.title
    fill_in "Url", with: @news.url
    click_on "Update News"

    assert_text "News was successfully updated"
    click_on "Back"
  end

  test "should destroy News" do
    visit news_url(@news)
    click_on "Destroy this news", match: :first

    assert_text "News was successfully destroyed"
  end
end
