require "application_system_test_case"

class UserTagsTest < ApplicationSystemTestCase
  setup do
    @auth_admin_user_tag = auth_admin_user_tags(:one)
  end

  test "visiting the index" do
    visit auth_admin_user_tags_url
    assert_selector "h1", text: "User Tags"
  end

  test "creating a User tag" do
    visit auth_admin_user_tags_url
    click_on "New User Tag"

    fill_in "Name", with: @auth_admin_user_tag.name
    fill_in "User tagged count", with: @auth_admin_user_tag.user_tagged_count
    click_on "Create User tag"

    assert_text "User tag was successfully created"
    click_on "Back"
  end

  test "updating a User tag" do
    visit auth_admin_user_tags_url
    click_on "Edit", match: :first

    fill_in "Name", with: @auth_admin_user_tag.name
    fill_in "User tagged count", with: @auth_admin_user_tag.user_tagged_count
    click_on "Update User tag"

    assert_text "User tag was successfully updated"
    click_on "Back"
  end

  test "destroying a User tag" do
    visit auth_admin_user_tags_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "User tag was successfully destroyed"
  end
end
