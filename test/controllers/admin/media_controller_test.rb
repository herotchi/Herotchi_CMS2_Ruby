require "test_helper"

class Admin::MediaControllerTest < ActionDispatch::IntegrationTest
  setup do
    @medium = media(:one)
  end

  test "should get index" do
    get admin_media_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_medium_url
    assert_response :success
  end

  test "should create medium" do
    assert_difference("Medium.count") do
      post admin_media_url, params: { medium: { alt: @medium.alt, media_flg: @medium.media_flg, release_flg: @medium.release_flg, url: @medium.url } }
    end

    assert_redirected_to admin_medium_url(Medium.last)
  end

  test "should show medium" do
    get admin_medium_url(@medium)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_medium_url(@medium)
    assert_response :success
  end

  test "should update medium" do
    patch admin_medium_url(@medium), params: { medium: { alt: @medium.alt, media_flg: @medium.media_flg, release_flg: @medium.release_flg, url: @medium.url } }
    assert_redirected_to admin_medium_url(@medium)
  end

  test "should destroy medium" do
    assert_difference("Medium.count", -1) do
      delete admin_medium_url(@medium)
    end

    assert_redirected_to admin_media_url
  end
end
