# == Schema Information
#
# Table name: meetings
#
#  id            :bigint           not null, primary key
#  match_id      :bigint           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  date          :date
#  time          :time
#  notes         :text
#  location      :string
#  location_type :string
#
require "test_helper"

class MeetingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
