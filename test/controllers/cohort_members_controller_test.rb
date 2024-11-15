require "test_helper"

class CohortMembersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cohort_member = cohort_members(:one)
  end

  test "should get index" do
    get cohort_members_url
    assert_response :success
  end

  test "should get new" do
    get new_cohort_member_url
    assert_response :success
  end

  test "should create cohort_member" do
    assert_difference("CohortMember.count") do
      post cohort_members_url,
           params: { cohort_member: { cohort_id_id: @cohort_member.cohort_id_id, role: @cohort_member.role,
                                      user_id_id: @cohort_member.user_id_id } }
    end

    assert_redirected_to cohort_member_url(CohortMember.last)
  end

  test "should show cohort_member" do
    get cohort_member_url(@cohort_member)
    assert_response :success
  end

  test "should get edit" do
    get edit_cohort_member_url(@cohort_member)
    assert_response :success
  end

  test "should update cohort_member" do
    patch cohort_member_url(@cohort_member),
          params: { cohort_member: { cohort_id_id: @cohort_member.cohort_id_id, role: @cohort_member.role,
                                     user_id_id: @cohort_member.user_id_id } }
    assert_redirected_to cohort_member_url(@cohort_member)
  end

  test "should destroy cohort_member" do
    assert_difference("CohortMember.count", -1) do
      delete cohort_member_url(@cohort_member)
    end

    assert_redirected_to cohort_members_url
  end
end
