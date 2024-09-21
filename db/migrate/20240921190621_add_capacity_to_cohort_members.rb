class AddCapacityToCohortMembers < ActiveRecord::Migration[7.1]
  def change
    add_column :cohort_members, :capacity, :integer
  end
end
