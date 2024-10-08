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
  belongs_to :match, required: true, class_name: "Match", foreign_key: "match_id"
  has_many :meetings, class_name: "Meeting", foreign_key: "review_id", dependent: :destroy

end
