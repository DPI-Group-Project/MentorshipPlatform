desc "Fill the database tables with some sample data"
task({ sample_data: :environment }) do
  starting = Time.zone.now
  p "Creating sample data..."

  Survey.delete_all
  Meeting.delete_all
  Match.delete_all
  ShortList.delete_all
  CohortMember.delete_all
  ProgramAdmin.delete_all
  Cohort.delete_all
  Program.delete_all
  User.delete_all

  people = Array.new(38) do
    {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name
    }
  end
  people << { first_name: "Alice", last_name: "Smith" }
  people << { first_name: "Bob", last_name: "James" }
  admins = []
  observers = []
  mentors = []
  mentees = []
  mentors_and_mentees = []
  role_hash = {}

  # Creating Users
  people.each do |person|
    status = { "archived" => 10, "inactive" => 40, "active" => 100 }.find { |_key, value| rand * 100 <= value }.first
    timezone = ["Eastern Standard Time (EST) - UTC-5", "Central Standard Time (CST) - UTC-6",
                "Pacific Standard Time (PST) - UTC-8", "Mountain Standard Time (MST) - UTC-7"].sample
    mentor_title = ["Software Engineer", "Consultant", "Technical Support", "IT Technician", "Project Manager",
                    "Product Manager", "UI/UX Designer", "Sales Coordinator"].sample
    inactive_reason = ["Did not like the platform.", "Did not have a good experience.", "I will be back!",
                       "Other"].sample
    role = { "admin" => 5, "observer" => 7, "mentor" => 25, "mentee" => 100 }.find do |_key, value|
      rand * 100 <= value
    end.first
    skills = %w[Java Ruby Python Communication Networking Organization Leadership Writing]
    user = User.create(
      email: "#{(person[:first_name]).downcase}@example.com",
      password: "password",
      first_name: (person[:first_name]).capitalize,
      last_name: (person[:last_name]).capitalize,
      phone_number: Faker::PhoneNumber.phone_number,
      bio: "#{Faker::Quotes::Shakespeare.hamlet_quote} #{Faker::Quotes::Shakespeare.hamlet_quote}",
      timezone:,
      title: case role
             when "admin"
               "Program Organizer"
             when "observer"
               "Observer"
             when "mentee"
               "Trainee"
             else
               role == "mentor" ? mentor_title : nil
             end,
      linkedin_link: "https://www.linkedin.com/in/#{(person[:first_name]).downcase}-#{(person[:last_name]).downcase}-#{Faker::Number.number(digits: 5)}/",
      status:,
      inactive_reason: status == "Inactive" ? inactive_reason : nil,
      skills_array: [skills.sample, skills.sample]
    )

    case role
    when "admin"
      admins << user
    when "mentor"
      mentors << user
      mentors_and_mentees << user
    when "mentee"
      mentees << user
      mentors_and_mentees << user
    when "observer"
      observers << user
    end

    role_hash.store(user, role)

    profile_pic = ["pic_1.png", "pic_2.png", "pic_3.png"].sample
    user.profile_picture.attach(
      io: File.open(Rails.root.join("db", "sample_files", profile_pic)),
      filename: profile_pic,
      content_type: "image/png"
    )
  end
  p "There are now #{User.count} users. [1/9]"

  # Creating Programs
  program_names = ["Full-Stack Software Development", "High School Coding Training", "Apprenticeship",
                   "Career Readiness", "TBD"]
  program_index = 0

  admins.each do |admin|
    if program_index < program_names.length
      Program.create(
        name: program_names[program_index],
        description: "This program is for the #{program_names[program_index]} DPI program",
        contact_id: admin.id
      )
    end
    program_index += 1
  end
  p "There are now #{Program.count} programs. [2/9]"

  # Creating Cohorts
  Program.all.find_each do |program|
    cohort_random_number = rand(1..2)
    count = 1
    cohort_random_number.times do
      start_date = Faker::Date.between(from: "2023-01-1", to: "2023-12-30")
      end_date = Faker::Date.between(from: "2024-1-30", to: "2025-12-30")
      shortlist_start_time = Faker::Date.between(from: start_date + 2.days, to: start_date + 3.days)
      shortlist_end_time = Faker::Date.between(from: shortlist_start_time + 1.day, to: shortlist_start_time + 3.days)

      Cohort.create(
        cohort_name: "Cohort #{count}",
        description: "This cohort is part of the #{program.name} program",
        program_id: program.id,
        creator_id: program.contact_id,
        contact_id: program.contact_id,
        start_date:,
        end_date:,
        shortlist_start_time:,
        shortlist_end_time:,
        required_meetings: [6, 10].sample
      )
      count += 1
    end
  end
  p "There are now #{Cohort.count} cohorts. [3/9]"

  next unless admins.length

  # Creating Program Admins
  admins.each do |admin|
    admin.email

    program = Program.all.sample

    id = program.id

    super_user = false

    ProgramAdmin.create!(
      program_id: id,
      user_id: admin.id,
      super_user: super_user
    )

    ProgramAdmin.first.update(super_user: true)
  end
  p "There are now #{ProgramAdmin.count} program admins. [4/9]"

  # Creating Cohort Members
  mentors_and_mentees.each do |user|
    cohort = Cohort.all.sample

    if cohort.nil?
      puts "No cohort available to assign user: #{user.email}"
      next
    end

    role = role_hash[user]
    capacity = ""
    if role_hash[user] == "mentor"
      role = "mentor"
      capacity = rand(2..4)
    elsif role_hash[user] == "mentee"
      role = "mentee"
    end

    CohortMember.create(
      email: user.email,
      cohort_id: cohort.id,
      role:,
      capacity:
    )
  end
  p "There are now #{CohortMember.count} cohort members. [5/9]"

  # Creating Shortlist
  cohort_ids = Cohort.pluck(:id)
  cohort_ids.each do |cohort_id|
    mentee_ids = CohortMember.mentee_user_ids_in_cohort(cohort_id)
    mentor_ids = CohortMember.mentor_user_ids_in_cohort(cohort_id)
    mentee_ids.each do |mentee|
      3.times do |i|
        ShortList.create(
          mentor_id: mentor_ids.sample,
          mentee_id: mentee,
          cohort_id: cohort_id,
          ranking: i + 1
        )
      end
    end
  end
  p "There are now #{ShortList.count} shortlists. [6/9]"

  # Creating Matches
  cohorts = Cohort.all
  cohorts.each do |cohort|
    CohortMatchingService.new(cohort).call
  end
  p "There are now #{Match.count} matches. [7/9]"

  # Creating Meetings
  matches = Match.all
  matches.each do |match|
    date = Faker::Date.between(from: "2025-01-1", to: "2026-12-30")
    time = ["2000-01-01 06:26:00 -0600","2000-01-01 15:04:00 -0600","2000-01-01 20:56:00 -0600","2000-01-01 1:27:00 -0600"].sample
    notes = Faker::TvShows::Simpsons.quote
    location_type = [ "Online", "In-person"].sample
    location = if location_type == "Online"
                platform = ["google-meet","zoom","microsoft-teams"].sample
                meeting_code = Faker::Number.number(digits: 10)
                "https://#{platform}/#{meeting_code}"
              else
                street_number = Faker::Number.number(digits: 4)
                directional_prefix = ["N","E","S","W"].sample
                street_name = ["Street","Stony Island","Moon","Burger","Sheriff","Woodland"].sample
                street_prefix = ["St.","Ave.","Rd."].sample
                "#{street_number} #{directional_prefix} #{street_name} #{street_prefix}"
              end

    Meeting.create(
      match_id: match.id,
      date:,
      time:,
      notes:,
      location:,
      location_type:
    )
  end
  p "There are now #{Meeting.count} meetings. [8/9]"

  # Creating Surveys
  matches = Match.all
  matches.each do |match|
    match_id = match.id
    responsive = [1, 2, 3, 4, 5].sample
    responsive_reason = Faker::Quote.famous_last_words
    experience = [1, 2, 3, 4, 5].sample
    experience_reason = Faker::Quote.famous_last_words
    rating = if responsive <= 2 || experience <= 2
               [1, 2, 3].sample
             else
               [4, 5].sample
             end
    additional_note = Faker::TvShows::Simpsons.quote

    Survey.create(
      match_id:,
      responsive:,
      responsive_reason:,
      experience:,
      experience_reason:,
      rating:,
      additional_note:
    )
  end
  p "There are now #{Survey.count} surveys. [9/9]"

  ending = Time.zone.now
  p "Done! It took #{(ending - starting).to_i} seconds to create sample data."
end
