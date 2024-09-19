# == Schema Information
#
# Table name: organizations
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  program_id :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class OrganizationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
