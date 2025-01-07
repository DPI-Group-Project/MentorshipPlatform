class AddCompositeUniquenessConstraintToShortList < ActiveRecord::Migration[7.2]
  def change
    add_index :short_lists, %i[mentor_id mentee_id cohort_id], unique: true, name: "index_short_lists_on_mentor_mentee_cohort"
  end
end
