require "application_system_test_case"

class AccountsTest < ApplicationSystemTestCase
  setup do
    @auth_my_account = auth_my_accounts(:one)
  end

  test "visiting the index" do
    visit auth_my_accounts_url
    assert_selector "h1", text: "Accounts"
  end

  test "creating a Account" do
    visit auth_my_accounts_url
    click_on "New Account"

    fill_in "Account", with: @auth_my_account.account
    fill_in "Confirmed", with: @auth_my_account.confirmed
    fill_in "Primary", with: @auth_my_account.primary
    click_on "Create Account"

    assert_text "Account was successfully created"
    click_on "Back"
  end

  test "updating a Account" do
    visit auth_my_accounts_url
    click_on "Edit", match: :first

    fill_in "Account", with: @auth_my_account.account
    fill_in "Confirmed", with: @auth_my_account.confirmed
    fill_in "Primary", with: @auth_my_account.primary
    click_on "Update Account"

    assert_text "Account was successfully updated"
    click_on "Back"
  end

  test "destroying a Account" do
    visit auth_my_accounts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Account was successfully destroyed"
  end
end
