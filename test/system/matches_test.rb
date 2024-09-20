require "application_system_test_case"

class MatchesTest < ApplicationSystemTestCase
  setup do
    @match = matches(:one)
  end

  test "visiting the index" do
    visit matches_url
    assert_selector "h1", text: "Matches"
  end

  test "should create match" do
    visit matches_url
    click_on "New match"

    check "Active" if @match.active
    fill_in "Cohort id", with: @match.cohort_id_id
    fill_in "Matches", with: @match.matches
    fill_in "Mentee id", with: @match.mentee_id_id
    fill_in "Mentor id", with: @match.mentor_id_id
    click_on "Create Match"

    assert_text "Match was successfully created"
    click_on "Back"
  end

  test "should update Match" do
    visit match_url(@match)
    click_on "Edit this match", match: :first

    check "Active" if @match.active
    fill_in "Cohort id", with: @match.cohort_id_id
    fill_in "Matches", with: @match.matches
    fill_in "Mentee id", with: @match.mentee_id_id
    fill_in "Mentor id", with: @match.mentor_id_id
    click_on "Update Match"

    assert_text "Match was successfully updated"
    click_on "Back"
  end

  test "should destroy Match" do
    visit match_url(@match)
    click_on "Destroy this match", match: :first

    assert_text "Match was successfully destroyed"
  end
end
