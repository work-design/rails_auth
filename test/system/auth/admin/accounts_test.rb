require "application_system_test_case"

class AccountsTest < ApplicationSystemTestCase
  setup do
    @auth_admin_account = auth_admin_accounts(:one)
  end

  test "visiting the index" do
    visit auth_admin_accounts_url
    assert_selector "h1", text: "Accounts"
  end

  test "creating a Account" do
    visit auth_admin_accounts_url
    click_on "New Account"

    fill_in "Confirmed", with: @auth_admin_account.confirmed
    fill_in "Identity", with: @auth_admin_account.identity
    fill_in "Primary", with: @auth_admin_account.primary
    fill_in "Type", with: @auth_admin_account.type
    fill_in "User", with: @auth_admin_account.user_id
    click_on "Create Account"

    assert_text "Account was successfully created"
    click_on "Back"
  end

  test "updating a Account" do
    visit auth_admin_accounts_url
    click_on "Edit", match: :first

    fill_in "Confirmed", with: @auth_admin_account.confirmed
    fill_in "Identity", with: @auth_admin_account.identity
    fill_in "Primary", with: @auth_admin_account.primary
    fill_in "Type", with: @auth_admin_account.type
    fill_in "User", with: @auth_admin_account.user_id
    click_on "Update Account"

    assert_text "Account was successfully updated"
    click_on "Back"
  end

  test "destroying a Account" do
    visit auth_admin_accounts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Account was successfully destroyed"
  end
end
