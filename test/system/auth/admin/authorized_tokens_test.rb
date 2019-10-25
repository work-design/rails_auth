require "application_system_test_case"

class AuthorizedTokensTest < ApplicationSystemTestCase
  setup do
    @auth_admin_authorized_token = auth_admin_authorized_tokens(:one)
  end

  test "visiting the index" do
    visit auth_admin_authorized_tokens_url
    assert_selector "h1", text: "Authorized Tokens"
  end

  test "creating a Authorized token" do
    visit auth_admin_authorized_tokens_url
    click_on "New Authorized Token"

    fill_in "Account", with: @auth_admin_authorized_token.account
    fill_in "Expire at", with: @auth_admin_authorized_token.expire_at
    fill_in "Oauth user", with: @auth_admin_authorized_token.oauth_user
    fill_in "Session key", with: @auth_admin_authorized_token.session_key
    fill_in "Token", with: @auth_admin_authorized_token.token
    fill_in "User", with: @auth_admin_authorized_token.user
    click_on "Create Authorized token"

    assert_text "Authorized token was successfully created"
    click_on "Back"
  end

  test "updating a Authorized token" do
    visit auth_admin_authorized_tokens_url
    click_on "Edit", match: :first

    fill_in "Account", with: @auth_admin_authorized_token.account
    fill_in "Expire at", with: @auth_admin_authorized_token.expire_at
    fill_in "Oauth user", with: @auth_admin_authorized_token.oauth_user
    fill_in "Session key", with: @auth_admin_authorized_token.session_key
    fill_in "Token", with: @auth_admin_authorized_token.token
    fill_in "User", with: @auth_admin_authorized_token.user
    click_on "Update Authorized token"

    assert_text "Authorized token was successfully updated"
    click_on "Back"
  end

  test "destroying a Authorized token" do
    visit auth_admin_authorized_tokens_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Authorized token was successfully destroyed"
  end
end
