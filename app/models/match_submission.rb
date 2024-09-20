# == Schema Information
#
# Table name: match_submissions
#
#  id         :bigint           not null, primary key
#  mentor_id  :bigint           not null
#  mentee_id  :bigint           not null
#  ranking    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class MatchSubmission < ApplicationRecord
  belongs_to :mentor_id
  belongs_to :mentee_id
end
