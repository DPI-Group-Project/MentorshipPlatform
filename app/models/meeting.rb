# == Schema Information
#
# Table name: meetings
#
#  id         :bigint           not null, primary key
#  match_id   :bigint           not null
#  complete   :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  date       :date
#  time       :time
#  notes      :text
#  location   :string
#
class Meeting < ApplicationRecord
  belongs_to :match, required: true, class_name: "Match", foreign_key: "match_id"
  belongs_to :review, required: true, class_name: "Review", foreign_key: "review_id"

  def mentor
    match.mentor
  end
  
end
