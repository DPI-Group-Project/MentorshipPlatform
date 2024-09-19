class Match < ApplicationRecord
  belongs_to :mentor_id
  belongs_to :mentee_id
  belongs_to :cohort_id
end
