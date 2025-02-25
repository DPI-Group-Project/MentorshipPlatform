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
#  status                 :enum             default("active")
#  inactive_reason        :text
#  phone_number           :string
#  bio                    :text
#  timezone               :string
#  title                  :string
#  linkedin_link          :string
#  skills_array           :text             default([]), is an Array
#  shortlist              :jsonb            is an Array
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_picture

  belongs_to :cohort_member, primary_key: "email", foreign_key: "email", optional: true, dependent: :destroy
  has_one :program_admin, primary_key: "id", dependent: :destroy
  has_one :mentor, class_name: "Match", foreign_key: "mentor_id", dependent: :destroy
  has_many :mentees, class_name: "Match", foreign_key: "mentee_id", dependent: :destroy
  has_many :mentor_submissions, class_name: "MatchSubmission", foreign_key: "mentor_id", dependent: :destroy
  has_many :mentee_submissions, class_name: "MatchSubmission", foreign_key: "mentee_id", dependent: :destroy
  has_many :owned_cohorts, class_name: "Cohort", foreign_key: "creator_id", dependent: :destroy
  has_many :owned_programs, class_name: "Program", foreign_key: "creator_id", dependent: :destroy
  has_many :matches, foreign_key: :mentor_id, class_name: "Match"
  has_many :meetings, through: :matches
  has_many :surveys, through: :matches, source: :surveys

  validates :email, uniqueness: true

  scope :mentors_in_cohort, lambda { |cohort_id|
                              joins(:cohort_member)
                                .where("cohort_members.cohort_id = ? AND cohort_members.role = ?", cohort_id, "mentor")
                            }
  scope :mentees_in_cohort, lambda { |cohort_id|
                              joins(:cohort_member)
                                .where("cohort_members.cohort_id = ? AND cohort_members.role = ?", cohort_id, "mentee")
                            }
  scope :unpaired_mentees_in_cohort, lambda { |cohort_id|
    joins(:cohort_member)
      .left_joins(:matches)
      .where(cohort_members: { cohort_id: cohort_id, role: "mentee" })
      .where(matches: { id: nil })
  }
  scope :mentors_with_capacity, lambda { |cohort_id|
    joins(:cohort_member)
      .where("cohort_members.cohort_id = ? AND cohort_members.role = ?", cohort_id, "mentor")
      .select { |mentor| mentor.mentee_capacity_count(cohort_id) < mentor.capacity }
  }

  def name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

  def matched?
    Match.where("mentee_id = :id OR mentor_id = :id", id:).exists?
  end

  def current_user_mentor
    match = Match.find_by(mentee_id: id)
    match ? User.find(match.mentor_id) : nil
  end

  def current_user_mentees
    matches = Match.where(mentor_id: id)
    matches.map { |match| User.find(match.mentee_id) }
  end

  def mentee_count
    current_user_mentees.size
  end

  def match_id
    match = Match.find_by(mentee_id: id)
    match.id
  end

  def cohort
    cohort_id = CohortMember.where(email:).pick(:cohort_id)
    Cohort.find_by(id: cohort_id)
  end

  def role
    cohort_member_role = CohortMember.where(email: email).pick(:role)

    cohort_member_role.presence || "admin"
  end

  def mentor?
    Match.exists?(mentor_id: id)
  end

  def mentee?
    Match.exists?(mentee_id: id)
  end

  def capacity
    CohortMember.where(email:).pick(:capacity)
  end

  def mentee_capacity_count(cohort_id)
    matches = Match.where("mentor_id = ? AND active = ? AND cohort_id = ?", id, "true", cohort_id)
    matches.size
  end
end
