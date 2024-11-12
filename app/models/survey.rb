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

	after_create :send_creation_notification

  private

  def send_creation_notification
    SurveyMailer.notify_admin_of_survey_creation(self).deliver_later
  end
end
