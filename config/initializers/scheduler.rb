require 'rufus-scheduler'

# Initialize a new scheduler instance
scheduler = Rufus::Scheduler.new
cohorts = Cohort.where.not(shortlist_start_time: nil)
      .where.not(shortlist_end_time: nil)

cohorts.each_with_index do |cohort, index|
  shortlist_end_date_[index] = cohort.shortlist_end_date
  scheduler.at "#{shortlist_end_date_[index]}" do
    # Call your task (the Matching logic)
    p "ITS TIME TO MATCH 1"
    # Match.run_matching(cohort.id)
  end
end
  
user_timezone = 'America/Chicago'
current_time = Time.current.in_time_zone(user_timezone)
current_time_in_user_zone = current_time.strftime('%Y-%m-%d %H:%M:%S UTC')
if current_time_in_user_zone == "2024-11-07 22:15:00"
  p "ITS TIME TO MATCH 2"
  scheduler.at "#{current_time}" do
    # Call your task (the Matching logic)
    # Match.run_matching(502)
  end
end