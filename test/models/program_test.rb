# == Schema Information
#
# Table name: programs
#
#  id                :bigint           not null, primary key
#  name              :string
#  description       :text
#  creator           :bigint           not null
#  contact           :bigint           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  required_meetings :integer
#
require "test_helper"

class ProgramTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
