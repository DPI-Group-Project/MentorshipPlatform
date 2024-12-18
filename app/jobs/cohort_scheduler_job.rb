class CohortSchedulerJob < ApplicationJob
  queue_as :default

  def perform(cohort_id)
    cohort = Cohort.find_by(id: cohort_id)
    return if cohort.nil?

    Rails.logger.info "Starting scheduled tasks for cohort ##{cohort.id} at #{Time.current}"

    # Schedule Shortlist Start Emails
    schedule_shortlist_start_notification(cohort)

    # Schedule Matching Execution
    schedule_matching(cohort)

    # Schedule Two-Week End Warning Emails
    schedule_two_week_warning(cohort)

    Rails.logger.info "Finished scheduling tasks for cohort ##{cohort.id} at #{Time.current}"
  end

  private

  # Notify members when shortlist creation starts
  def schedule_shortlist_start_notification(cohort)
    return unless cohort.shortlist_start_time

    Rails.logger.info "Scheduling shortlist start notification for cohort ##{cohort.id}"
    Scheduler.at(cohort.shortlist_start_time) do
      cohort.members.each do |member|
        CohortMailer.shortlist_start_notification(member.user, cohort).deliver_later
      end
      Rails.logger.info "Shortlist start notification sent for cohort ##{cohort.id}"
    end
  end

  # Execute matching at the end of the shortlist phase
  def schedule_matching(cohort)
    return unless cohort.shortlist_end_time

    Rails.logger.info "Scheduling matching for cohort ##{cohort.id}"
    Scheduler.at(cohort.shortlist_end_time) do
      CohortMatchingService.new(cohort).call
      cohort.send_matching_results_emails
      Rails.logger.info "Matches created and results emailed for cohort ##{cohort.id}"
    end
  end

  # Send warning emails to admin and members 2 weeks before cohort ends
  def schedule_two_week_warning(cohort)
    return unless cohort.end_date

    warning_time = cohort.end_date - 14.days
    Rails.logger.info "Scheduling two-week warning for cohort ##{cohort.id} at #{warning_time}"

    Scheduler.at(warning_time) do
      # Notify cohort creator (admin)
      CohortMailer.two_week_warning(cohort.creator.email, cohort).deliver_later

      # Notify each cohort member
      cohort.members.each do |member|
        CohortMailer.survey_reminder(member, cohort).deliver_later
      end

      # Final reminder to the admin
      CohortMailer.survey_reminder(nil, cohort, cohort.creator.email).deliver_later
      Rails.logger.info "Two-week warning emails sent for cohort ##{cohort.id}"
    end
  end
end
