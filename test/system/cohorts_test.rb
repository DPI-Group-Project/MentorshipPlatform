require "application_system_test_case"

class CohortsTest < ApplicationSystemTestCase
  setup do
    @cohort = cohorts(:one)
  end

  test "visiting the index" do
    visit cohorts_url
    assert_selector "h1", text: "Cohorts"
  end

  test "should create cohort" do
    visit cohorts_url
    click_on "New cohort"

    fill_in "Cohort name", with: @cohort.cohort_name
    fill_in "Contact", with: @cohort.contact_id
    fill_in "Creator", with: @cohort.creator_id
    fill_in "Description", with: @cohort.description
    fill_in "End date", with: @cohort.end_date
    fill_in "Program", with: @cohort.program_id
    fill_in "Start date", with: @cohort.start_date
    click_on "Create Cohort"

    assert_text "Cohort was successfully created"
    click_on "Back"
  end

  test "should update Cohort" do
    visit cohort_url(@cohort)
    click_on "Edit this cohort", match: :first

    fill_in "Cohort name", with: @cohort.cohort_name
    fill_in "Contact", with: @cohort.contact_id
    fill_in "Creator", with: @cohort.creator_id
    fill_in "Description", with: @cohort.description
    fill_in "End date", with: @cohort.end_date
    fill_in "Program", with: @cohort.program_id
    fill_in "Start date", with: @cohort.start_date
    click_on "Update Cohort"

    assert_text "Cohort was successfully updated"
    click_on "Back"
  end

  test "should destroy Cohort" do
    visit cohort_url(@cohort)
    click_on "Destroy this cohort", match: :first

    assert_text "Cohort was successfully destroyed"
  end
end
