require 'rufus-scheduler'

Rails.application.config.to_prepare do
  # Initialize a new scheduler instance
  scheduler = Rufus::Scheduler.new

  cohorts = Cohort.where.not(shortlist_start_time: nil)
        .where.not(shortlist_end_time: nil)

  cohorts.each_with_index do |cohort, index|
    shortlist_end_date = cohort.shortlist_end_time.in_time_zone.utc
    scheduler.at shortlist_end_date do
      p cohort.id
      p "ITS TIME TO MATCH 2"
      Rails.logger.info "Triggering match creation for cohort ##{cohort.id}"
      MatchesController.new.create_for_cohort(cohort)
    end
  end
end