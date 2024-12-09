# == Schema Information
#
# Table name: programs
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  contact_id  :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "test_helper"

class ProgramTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
