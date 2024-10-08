# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  first_name             :string
#  last_name              :string
#  status                 :string
#  inactive_reason        :text
#  phone_number           :string
#  bio                    :text
#  timezone               :string
#  title                  :string
#  linkedin_link          :string
#  profile_picture        :string
#  skills_array           :text             default([]), is an Array
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :cohort_members, class_name: "CohortMember", foreign_key: "user_id", dependent: :destroy
  has_one :mentor, class_name: "Match", foreign_key: "mentor_id", dependent: :destroy
  has_many :mentees, class_name: "Match", foreign_key: "mentee_id", dependent: :destroy
  has_many :mentor_submissions, class_name: "MatchSubmission", foreign_key: "mentor_id", dependent: :destroy
  has_many :mentee_submissions, class_name: "MatchSubmission", foreign_key: "mentee_id", dependent: :destroy
  has_many :owned_cohorts, class_name: "Cohort", foreign_key: "creator_id", dependent: :destroy
  has_many :owned_programs, class_name: "Program", foreign_key: "creator_id", dependent: :destroy
  
  scope :mentors_in_cohort, ->(cohort) { joins(:cohort_members)
                                  .where('cohort_members.cohort_id = ? AND cohort_members.role = ?', cohort, 'Mentor')}
  def cohort
    CohortMember.where(user_id: self.id).pluck(:cohort_id).first
  end
  
  accepts_nested_attributes_for :cohort_members
  after_create :create_first_cohort
  attr_accessor :cohorts_attributes

  before_create :set_default_active_status

  private

  def create_first_cohort
    return unless cohorts_attributes.present?

    cohorts_attributes.each do |_, attributes|
      cohorts.create!(
        role: attributes[:role],
        capacity: attributes[:capacity],
        cohort_id: attributes[:cohort_id] || Cohort.first&.id
      )
    end
  end

  def set_default_active_status
    self.status ||= 'Active'
  end
end
