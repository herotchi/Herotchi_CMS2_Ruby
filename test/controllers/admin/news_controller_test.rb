require "test_helper"

class Admin::NewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @news = news(:one)
  end

  test "should get index" do
    get admin_news_index_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_news_url
    assert_response :success
  end

  test "should create news" do
    assert_difference("News.count") do
      post admin_news_index_url, params: { news: { link_flg: @news.link_flg, overview: @news.overview, release_date: @news.release_date, release_flg: @news.release_flg, title: @news.title, url: @news.url } }
    end

    assert_redirected_to admin_news_url(News.last)
  end

  test "should show news" do
    get admin_news_url(@news)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_news_url(@news)
    assert_response :success
  end

  test "should update news" do
    patch admin_news_url(@news), params: { news: { link_flg: @news.link_flg, overview: @news.overview, release_date: @news.release_date, release_flg: @news.release_flg, title: @news.title, url: @news.url } }
    assert_redirected_to admin_news_url(@news)
  end

  test "should destroy news" do
    assert_difference("News.count", -1) do
      delete admin_news_url(@news)
    end

    assert_redirected_to admin_news_index_url
  end
end
