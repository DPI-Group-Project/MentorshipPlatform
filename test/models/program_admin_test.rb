# == Schema Information
#
# Table name: program_admins
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  program_id :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class ProgramAdminTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
