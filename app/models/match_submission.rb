class MatchSubmission < ApplicationRecord
  belongs_to :mentor_id
  belongs_to :mentee_id
end
