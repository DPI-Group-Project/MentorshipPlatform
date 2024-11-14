# == Schema Information
#
# Table name: meetings
#
#  id            :bigint           not null, primary key
#  match_id      :bigint           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  date          :date
#  time          :time
#  notes         :text
#  location      :string
#  location_type :string
#
class Meeting < ApplicationRecord
  belongs_to :match, required: true, class_name: "Match", foreign_key: "match_id"

  def mentor
    match.mentor
  end
end
