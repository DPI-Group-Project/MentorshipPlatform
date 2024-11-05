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
#  shortlist              :jsonb            is an Array
#
require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
