# == Schema Information
#
# Table name: cohort_members
#
#  id         :bigint           not null, primary key
#  email      :string           not null
#  cohort_id  :bigint           not null
#  role       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  capacity   :integer
#
require "test_helper"

class CohortMemberTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
