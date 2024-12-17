class CohortMatchingService
  def initialize(cohort)
    @cohort = cohort
    @shortlist = ShortList.for_cohort(cohort.id).ordered
    @created_matches = []
    @skipped_matches = []
  end

  def call
    Rails.logger.info "Starting match creation for cohort ##{@cohort.id} at #{Time.current}"

    @shortlist.each do |shortlist_entry|
      mentor = User.find_by(id: shortlist_entry.mentor_id)
      mentee = User.find_by(id: shortlist_entry.mentee_id)

      if mentor.nil? || mentee.nil?
        log_skip(shortlist_entry, "Mentor or mentee not found")
        next
      end

      if match_exists?(mentee)
        log_skip(shortlist_entry, "Match already exists for mentee")
        next
      end

      cohort_member = find_cohort_member(mentor)
      if cohort_member.nil? || mentor_capacity_reached?(mentor, cohort_member.capacity)
        log_skip(shortlist_entry, "Mentor capacity reached or invalid cohort member")
        next
      end

      create_match(shortlist_entry, mentor, mentee)
    end

    send_emails
    log_summary
  end

  private

  def create_match(shortlist_entry, mentor, mentee)
    Match.create!(
      mentor_id: mentor.id,
      mentee_id: mentee.id,
      cohort_id: @cohort.id,
      active: true
    )
    @created_matches << { mentor: mentor.email, mentee: mentee.email }
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Failed to create match for shortlist entry ##{shortlist_entry.id}: #{e.message}"
  end

  def log_skip(shortlist_entry, reason)
    Rails.logger.warn "Skipped match creation for shortlist entry ##{shortlist_entry.id}: #{reason}"
    @skipped_matches << { shortlist_id: shortlist_entry.id, reason: reason }
  end

  def match_exists?(mentee)
    Match.exists?(mentee_id: mentee.id, cohort_id: @cohort.id)
  end

  def find_cohort_member(mentor)
    CohortMember.find_by(email: mentor.email, cohort_id: @cohort.id)
  end

  def mentor_capacity_reached?(mentor, capacity)
    return true if capacity.nil?

    mentor.mentee_capacity_count(@cohort.id) >= capacity
  end

  def send_emails
    @cohort.send_matching_results_emails
  end

  def log_summary
    Rails.logger.info "Match creation completed for cohort ##{@cohort.id}"
    Rails.logger.info "Created matches: #{@created_matches.count}"
    Rails.logger.info "Skipped matches: #{@skipped_matches.count}"
  end
end
