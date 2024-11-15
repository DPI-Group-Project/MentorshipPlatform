# == Schema Information
#
# Table name: reviews
#
#  id              :bigint           not null, primary key
#  match_id        :bigint           not null
#  responsive      :string
#  answer_if_other :text
#  feedback        :text
#  rating          :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Review < ApplicationRecord
  belongs_to :match, optional: false, class_name: "Match"
  # has_many :meetings, class_name: "Meeting", foreign_key: "review_id", dependent: :destroy
end
