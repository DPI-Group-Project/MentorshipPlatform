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
  
  # Returns list of mentees that are in the same cohort as the provided mentor
  scope :mentors_in_cohort, ->(cohort) { joins(:cohort_members)
                                  .where('cohort_members.cohort_id = ? AND cohort_members.role = ?', cohort, 'Mentor')}
  scope :mentees_in_cohort, ->(cohort) { joins(:cohort_members)
                                  .where('cohort_members.cohort_id = ? AND cohort_members.role = ?', cohort, 'Mentee')}
  scope :unpaired_mentees_in_cohort, ->(cohort) { joins(:cohort_members)
                                  .left_joins('LEFT JOIN matches ON matches.mentee_id = users.id AND matches.active = true')
                                  .where('cohort_members.cohort_id = ? AND cohort_members.role = ?', cohort, 'Mentee')
                                  .where('matches.id IS NULL')}
  def matched?
    Match.where('mentee_id = :id OR mentor_id = :id', id: self.id).exists?
  end
  def cohort
    CohortMember.where(user_id: self.id).pluck(:cohort_id).first
  end
  def role
    CohortMember.where(user_id: self.id).pluck(:role).first
  end
  def capacity
    CohortMember.where(user_id: self.id).pluck(:capacity).first
  end
  # Return how many mentees a mentor currently has
  def mentee_capacity_count(cohort_id)
    matches = Match.where('mentor_id = ? AND active = ? AND cohort_id = ?', self.id, 'true', cohort_id)
    matches.size
  end
end
