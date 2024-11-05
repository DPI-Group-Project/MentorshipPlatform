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
end
