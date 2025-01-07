require "rufus-scheduler"

Rails.application.config.to_prepare do
  thread_to_kill = Thread.list.find { |t| t[:name] == "rufus_scheduler_17900_scheduler" }
  thread_to_kill&.kill
  Rails.logger.debug "Initiating Matching Thread"

  @scheduler_thread = Thread.new(name: "MatchingThreadInSchedulerFile") do
    scheduler = Rufus::Scheduler.new

    cohorts = Cohort.where.not(start_date: nil)
                    .where.not(end_date: nil)
                    .where.not(shortlist_start_time: nil)
                    .where.not(shortlist_end_time: nil)

    cohorts.each do |cohort|
      Rails.logger.debug "Scheduling CohortSchedulerJob for cohort ##{cohort.id}"

      # Enqueue the CohortSchedulerJob
      scheduler.in "1s" do
        CohortSchedulerJob.perform_now(cohort.id)
        Rails.logger.debug "CohortSchedulerJob enqueued for cohort ##{cohort.id}"
      end
    end
  end
end
