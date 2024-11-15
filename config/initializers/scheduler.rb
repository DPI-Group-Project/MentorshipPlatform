require "rufus-scheduler"

Rails.application.config.to_prepare do
  thread_to_kill = Thread.list.find { |t| t[:name] == "rufus_scheduler_17900_scheduler" }
  thread_to_kill&.kill
  Rails.logger.debug "Initiating Matching Thread"
  @scheduler_thread = Thread.new(name: "MatchingThreadInSchedulerFile") do
    require "rufus-scheduler"
    # Initialize a new scheduler instance
    scheduler = Rufus::Scheduler.new
    cohorts = Cohort.where.not(start_date: nil)
                    .where.not(end_date: nil)
                    .where.not(shortlist_start_time: nil)
                    .where.not(shortlist_end_time: nil)

    cohorts.each do |cohort|
      shortlist_end_date = cohort.shortlist_end_time.in_time_zone.utc

      # trigger matching when the scheduler is reached
      scheduler.at shortlist_end_date do
        MatchesController.new.create_for_cohort(cohort)
      end

      # Schedule the email notification at the shortlist start time
      scheduler.at cohort.shortlist_start_time.in_time_zone.utc do
        Rails.logger.debug "Shortlist Open Email sent for cohort ##{cohort.id}"
        cohort.members.each do |member|
          CohortMailer.shortlist_start_notification(member.user, cohort).deliver_later!
        end
      end

      subtract_2_weeks = cohort.end_date.in_time_zone.utc - 14.days
      Rails.logger.debug subtract_2_weeks

      # send warning email to admin that cohort is ending in 2 weeks
      scheduler.at subtract_2_weeks do
        CohortMailer.two_week_warning(cohort.creator.email, cohort).deliver_later!

        cohort_members = CohortMember.where(cohort_id: cohort.id)
        # remind each cohort member about survey
        Rails.logger.debug "POOP!1"
        cohort_members.each do |member|
          Rails.logger.debug "#{member} POOP!2"
          CohortMailer.survey_reminder(member, cohort).deliver_later!
        end

        CohortMailer.survey_reminder(nil, cohort, cohort.creator.email).deliver_later!
      end
    end
  end
end
