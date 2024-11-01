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

  belongs_to :cohort_member, primary_key: 'email', foreign_key: 'email', optional: true, dependent: :destroy
  has_one :mentor, class_name: 'Match', foreign_key: 'mentor_id', dependent: :destroy
  has_many :mentees, class_name: 'Match', foreign_key: 'mentee_id', dependent: :destroy
  has_many :mentor_submissions, class_name: 'MatchSubmission', foreign_key: 'mentor_id', dependent: :destroy
  has_many :mentee_submissions, class_name: 'MatchSubmission', foreign_key: 'mentee_id', dependent: :destroy
  has_many :owned_cohorts, class_name: 'Cohort', foreign_key: 'creator_id', dependent: :destroy
  has_many :owned_programs, class_name: 'Program', foreign_key: 'creator_id', dependent: :destroy

  validates :email, uniqueness: true

  accepts_nested_attributes_for :cohort_members
  attr_accessor :cohort_members_attributes

  before_create :set_default_active_status

  # Returns list of mentees that are in the same cohort as the provided mentor
  scope :mentors_in_cohort, lambda { |cohort|
                              joins(:cohort_members)
                                .where('cohort_members.cohort_id = ? AND cohort_members.role = ?', cohort, 'mentor')
                            }
  scope :mentees_in_cohort, lambda { |cohort|
                              joins(:cohort_members)
                                .where('cohort_members.cohort_id = ? AND cohort_members.role = ?', cohort, 'mentee')
                            }
  scope :unpaired_mentees_in_cohort, lambda { |cohort|
                                       joins(:cohort_members)
                                         .left_joins('LEFT JOIN matches ON matches.mentee_id = users.id AND matches.active = true')
                                         .where('cohort_members.cohort_id = ? AND cohort_members.role = ?', cohort, 'mentee')
                                         .where('matches.id IS NULL')
                                     }

  def name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

  def matched?
    Match.where('mentee_id = :id OR mentor_id = :id', id:).exists?
  end

  def cohort
    cohort_id = CohortMember.where(email:).pluck(:cohort_id).first
    cohort = Cohort.find_by(id: cohort_id)
  end

  def role
    CohortMember.where(email:).pluck(:role).first
  end

  def capacity
    CohortMember.where(email:).pluck(:capacity).first
  end

  # Return how many mentees a mentor currently has
  def mentee_capacity_count(cohort_id)
    matches = Match.where('mentor_id = ? AND active = ? AND cohort_id = ?', id, 'true', cohort_id)
    matches.size
  end

  private

  def set_default_active_status
    self.status ||= 'Active'
  end
end
