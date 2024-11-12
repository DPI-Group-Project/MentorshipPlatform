# == Schema Information
#
# Table name: surveys
#
#  id              :bigint           not null, primary key
#  match_id        :integer
#  responsive      :boolean
#  answer_if_other :string
#  body            :text
#  rating          :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Survey < ApplicationRecord
	validates :match_id, presence: true
	belongs_to :match, required: true, class_name: "Match", foreign_key: "match_id"
end
