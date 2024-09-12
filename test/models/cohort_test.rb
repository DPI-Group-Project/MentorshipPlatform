# == Schema Information
#
# Table name: cohorts
#
#  id          :bigint           not null, primary key
#  program_id  :integer
#  cohort_name :string
#  description :text
#  start_date  :datetime
#  end_date    :datetime
#  creator_id  :integer
#  contact_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "test_helper"

class CohortTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
