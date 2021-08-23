require "application_system_test_case"

class AppsTest < ApplicationSystemTestCase
  setup do
    @auth_panel_app = auth_panel_apps(:one)
  end

  test "visiting the index" do
    visit auth_panel_apps_url
    assert_selector "h1", text: "Apps"
  end

  test "creating a App" do
    visit auth_panel_apps_url
    click_on "New App"

    fill_in "Appid", with: @auth_panel_app.appid
    fill_in "Jwt key", with: @auth_panel_app.jwt_key
    click_on "Create App"

    assert_text "App was successfully created"
    click_on "Back"
  end

  test "updating a App" do
    visit auth_panel_apps_url
    click_on "Edit", match: :first

    fill_in "Appid", with: @auth_panel_app.appid
    fill_in "Jwt key", with: @auth_panel_app.jwt_key
    click_on "Update App"

    assert_text "App was successfully updated"
    click_on "Back"
  end

  test "destroying a App" do
    visit auth_panel_apps_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "App was successfully destroyed"
  end
end
