require "test_helper"

class Helm::PagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @page = pages(:one)
  end

  test "should get index" do
    get helm_pages_url
    assert_response :success
  end

  test "should get new" do
    get new_helm_page_url
    assert_response :success
  end

  test "should create page" do
    assert_difference("Page.count") do
      post helm_pages_url, params: { page: {  } }
    end

    assert_redirected_to helm_page_url(Page.last)
  end

  test "should show page" do
    get helm_page_url(@page)
    assert_response :success
  end

  test "should get edit" do
    get edit_helm_page_url(@page)
    assert_response :success
  end

  test "should update page" do
    patch helm_page_url(@page), params: { page: {  } }
    assert_redirected_to helm_page_url(@page)
  end

  test "should destroy page" do
    assert_difference("Page.count", -1) do
      delete helm_page_url(@page)
    end

    assert_redirected_to helm_pages_url
  end
end
