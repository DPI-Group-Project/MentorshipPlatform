# == Schema Information
#
# Table name: programs
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  creator_id  :bigint           not null
#  contact_id  :bigint           not null
#  passcode    :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Program < ApplicationRecord
  belongs_to :creator_id
  belongs_to :contact_id
end
