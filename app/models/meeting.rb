# == Schema Information
#
# Table name: meetings
#
#  id         :bigint           not null, primary key
#  match_id   :bigint           not null
#  time       :datetime
#  complete   :boolean
#  review_id  :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Meeting < ApplicationRecord
  belongs_to :match
  belongs_to :review
end
