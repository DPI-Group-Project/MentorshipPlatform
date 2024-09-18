# == Schema Information
#
# Table name: reviews
#
#  id         :bigint           not null, primary key
#  match_id   :bigint           not null
#  responsive :string
#  body       :text
#  rating     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class ReviewTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
