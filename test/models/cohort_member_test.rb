# == Schema Information
#
# Table name: cohort_members
#
#  cohort_id  :bigint           not null
#  email      :string           not null
#  role       :enum
#  capacity   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class CohortMemberTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
