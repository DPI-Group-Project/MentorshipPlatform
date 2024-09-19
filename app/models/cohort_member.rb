class CohortMember < ApplicationRecord
  belongs_to :user_id
  belongs_to :cohort_id
end
