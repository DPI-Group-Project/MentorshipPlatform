# == Schema Information
#
# Table name: cohort_members
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  cohort_id  :bigint           not null
#  role       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class CohortMemberTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
