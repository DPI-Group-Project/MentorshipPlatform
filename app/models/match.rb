# == Schema Information
#
# Table name: matches
#
#  id         :bigint           not null, primary key
#  mentor_id  :bigint           not null
#  mentee_id  :bigint           not null
#  cohort_id  :bigint           not null
#  active     :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Match < ApplicationRecord
  belongs_to :mentor, optional: false, class_name: "User"
  belongs_to :mentee, optional: false, class_name: "User"
  belongs_to :cohort, optional: false, class_name: "Cohort"
  has_many :meetings, class_name: "Meeting", dependent: :destroy
  has_many :surveys, class_name: "Survey", dependent: :destroy

  after_create :send_match_created_email

  def send_match_created_email
    Rails.logger.debug "Emails sent matched users"
    MatchMailer.match_created(self).deliver_later
  end
end
