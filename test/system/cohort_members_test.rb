require "application_system_test_case"

class CohortMembersTest < ApplicationSystemTestCase
  setup do
    @cohort_member = cohort_members(:one)
  end

  test "visiting the index" do
    visit cohort_members_url
    assert_selector "h1", text: "Cohort members"
  end

  test "should create cohort member" do
    visit cohort_members_url
    click_on "New cohort member"

    fill_in "Cohort id", with: @cohort_member.cohort_id_id
    fill_in "Role", with: @cohort_member.role
    fill_in "User id", with: @cohort_member.user_id_id
    click_on "Create Cohort member"

    assert_text "Cohort member was successfully created"
    click_on "Back"
  end

  test "should update Cohort member" do
    visit cohort_member_url(@cohort_member)
    click_on "Edit this cohort member", match: :first

    fill_in "Cohort id", with: @cohort_member.cohort_id_id
    fill_in "Role", with: @cohort_member.role
    fill_in "User id", with: @cohort_member.user_id_id
    click_on "Update Cohort member"

    assert_text "Cohort member was successfully updated"
    click_on "Back"
  end

  test "should destroy Cohort member" do
    visit cohort_member_url(@cohort_member)
    click_on "Destroy this cohort member", match: :first

    assert_text "Cohort member was successfully destroyed"
  end
end
