require "test_helper"

class CohortsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cohort = cohorts(:one)
  end

  test "should get index" do
    get cohorts_url
    assert_response :success
  end

  test "should get new" do
    get new_cohort_url
    assert_response :success
  end

  test "should create cohort" do
    assert_difference("Cohort.count") do
      post cohorts_url, params: { cohort: { cohort_name: @cohort.cohort_name, contact_id: @cohort.contact_id, creator_id: @cohort.creator_id, description: @cohort.description, end_date: @cohort.end_date, program_id: @cohort.program_id, start_date: @cohort.start_date } }
    end

    assert_redirected_to cohort_url(Cohort.last)
  end

  test "should show cohort" do
    get cohort_url(@cohort)
    assert_response :success
  end

  test "should get edit" do
    get edit_cohort_url(@cohort)
    assert_response :success
  end

  test "should update cohort" do
    patch cohort_url(@cohort), params: { cohort: { cohort_name: @cohort.cohort_name, contact_id: @cohort.contact_id, creator_id: @cohort.creator_id, description: @cohort.description, end_date: @cohort.end_date, program_id: @cohort.program_id, start_date: @cohort.start_date } }
    assert_redirected_to cohort_url(@cohort)
  end

  test "should destroy cohort" do
    assert_difference("Cohort.count", -1) do
      delete cohort_url(@cohort)
    end

    assert_redirected_to cohorts_url
  end
end
