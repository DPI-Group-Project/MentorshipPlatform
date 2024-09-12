require "application_system_test_case"

class ProgramsTest < ApplicationSystemTestCase
  setup do
    @program = programs(:one)
  end

  test "visiting the index" do
    visit programs_url
    assert_selector "h1", text: "Programs"
  end

  test "should create program" do
    visit programs_url
    click_on "New program"

    fill_in "Contact", with: @program.contact_id
    fill_in "Creator", with: @program.creator_id
    fill_in "Description", with: @program.description
    fill_in "Name", with: @program.name
    click_on "Create Program"

    assert_text "Program was successfully created"
    click_on "Back"
  end

  test "should update Program" do
    visit program_url(@program)
    click_on "Edit this program", match: :first

    fill_in "Contact", with: @program.contact_id
    fill_in "Creator", with: @program.creator_id
    fill_in "Description", with: @program.description
    fill_in "Name", with: @program.name
    click_on "Update Program"

    assert_text "Program was successfully updated"
    click_on "Back"
  end

  test "should destroy Program" do
    visit program_url(@program)
    click_on "Destroy this program", match: :first

    assert_text "Program was successfully destroyed"
  end
end
