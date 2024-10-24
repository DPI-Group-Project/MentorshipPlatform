desc 'Fill the database tables with some sample data'
task({ sample_data: :environment }) do
  starting = Time.now
  p 'Creating sample data...'

  Match.delete_all
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
  people << { first_name: 'Alice', last_name: 'Smith' }
  people << { first_name: 'Bob', last_name: 'James' }

  image_name = %w[Buddy Mimi Abby Jack Lily Lucy Jasmine Bear Loki Dusty Maggie Milo Lucky
                  Pepper Baby Boo Sammy Coco Mittens Socks]
  admins = []
  observers = []
  mentors = []
  mentees = []
  mentors_and_mentees = []
  role_hash = {}

  # Creating Users
  people.each do |person|
    status = { 'Archived' => 10, 'Inactive' => 40, 'Active' => 100 }.find { |_key, value| rand * 100 <= value }.first
    timezone = ['Eastern Standard Time (EST) - UTC-5', 'Central Standard Time (CST) - UTC-6',
                'Pacific Standard Time (PST) - UTC-8', 'Mountain Standard Time (MST) - UTC-7'].sample
    mentor_title = ['Software Engineer', 'Consultant', 'Technical Support', 'IT Technician', 'Project Manager',
                    'Product Manager', 'UI/UX Designer', 'Sales Coordinator'].sample
    inactive_reason = ['Did not like the platform.', 'Did not have a good experience.', 'I will be back!',
                       'Other'].sample
    role = { 'admin' => 5, 'observer' => 7, 'mentor' => 25, 'mentee' => 100 }.find { |_key, value| rand * 100 <= value }.first
    image_link = "https://api.dicebear.com/9.x/notionists/svg?seed=#{image_name.sample}&radius=50&backgroundColor=D2042D&bodyIcon=galaxy,
                  saturn,electric&bodyIconProbability=10&gesture=hand,handPhone,ok,okLongArm,point,pointLongArm,waveLongArm&gestureProbability=20&
                  lips=variant01,variant02,variant03,variant04,variant05,variant06,variant07,variant08,variant10,variant11,variant13,
                  variant14,variant15,variant16,variant17,variant18,variant19,variant20,variant21,variant22,variant23,variant24,variant25,
                  variant26,variant27,variant29,variant30"
    skills = %w[Java Ruby Python Communication Networking Organization Leadership Writing]

    user = User.create(
      email: "#{(person[:first_name]).downcase}@example.com",
      password: 'password',
      first_name: (person[:first_name]).capitalize,
      last_name: (person[:last_name]).capitalize,
      phone_number: Faker::PhoneNumber.phone_number,
      bio: "#{Faker::Quotes::Shakespeare.hamlet_quote} #{Faker::Quotes::Shakespeare.hamlet_quote}",
      timezone:,
      title: if role == 'admin'
               'Program Organizer'
             elsif role == 'observer'
               'Observer'
             elsif role == 'mentee'
               'Trainee'
             else
               role == 'mentor' ? mentor_title : nil
             end,
      linkedin_link: "https://www.linkedin.com/in/#{(person[:first_name]).downcase}-#{(person[:last_name]).downcase}-#{Faker::Number.number(digits: 5)}/",
      profile_picture: image_link,
      status:,
      inactive_reason: status == 'Inactive' ? inactive_reason : nil,
      skills_array: [skills.sample, skills.sample]
    )

    case role
    when 'admin'
      admins << user
    when 'mentor'
      mentors << user
      mentors_and_mentees << user
    when 'mentee'
      mentees << user
      mentors_and_mentees << user
    when 'observer'
      observers << user
    end

    role_hash.store(user, role)
  end

  # Creating Programs
  program_names = ['Full-Stack Software Development', 'High School Coding Training', 'Apprenticeship',
                   'Career Readiness', 'TBD']
  program_index = 0

  admins.each do |admin|
    program_passcode = Faker::Number.number(digits: 8).to_s

    if program_index < program_names.length
      Program.create(
        name: program_names[program_index],
        description: "This program is for the #{program_names[program_index]} DPI program",
        creator_id: admin.id,
        contact_id: admin.id,
        passcode: program_passcode
      )
    end
    program_index += 1
  end

  # Creating Cohorts
  Program.all.each do |program|
    cohort_random_number = rand(1..2)
    count = 1
    cohort_random_number.times do
      start_date = Faker::Date.between(from: '2023-01-1', to: '2023-12-30')
      end_date = Faker::Date.between(from: '2024-1-30', to: '2025-12-30')

      Cohort.create(
        cohort_name: "Cohort #{count}",
        description: "This cohort is part of the #{program.name} program",
        program_id: program.id,
        creator_id: program.creator_id,
        contact_id: program.creator_id,
        start_date:,
        end_date:,
        required_meetings: [6, 10].sample
      )
      count += 1
    end
  end

  # Creating Program Admins
  admins.each do |admin|
    program = Program.find_by(creator_id: admin.id)
    ProgramAdmin.create(
      user_id: admin.id,
      program_id: program.id
    )
  end

  # Creating Cohort Members
  mentors_and_mentees.each do |user|
    cohort = Cohort.all.sample

    if cohort.nil?
      puts "No cohort available to assign user: #{user.email}"
      next
    end

    role = role_hash[user]
    capacity = ''
    if role_hash[user] == 'mentor'
      role = 'mentor'
      capacity = rand(2..4)
    elsif role_hash[user] == 'mentee'
      role = 'mentee'
    end

    CohortMember.create(
      email: user.email,
      cohort_id: cohort.id,
      role:,
      capacity:
    )
  end

  # Creating Matches
  mentees.each do |mentee|
    cohort_member_mentee = mentee.cohort_members.first
    if cohort_member_mentee.nil?
      puts "No cohort member found for mentee with email: #{mentee.email}"
      next # Skip to the next mentee
    end
    mentor_cohort_member_object = CohortMember.where(cohort_id: cohort_member_mentee.cohort_id, role: 'mentor').sample
    shared_cohort = Cohort.find_by(id: cohort_member_mentee.cohort_id)
    this_mentor = User.find_by(email: mentor_cohort_member_object.email)
    Match.create(
      mentor_id: this_mentor.id,
      mentee_id: mentee.id,
      cohort_id: cohort_member_mentee.cohort_id,
      active: shared_cohort.running?
    )
  end

  ending = Time.now
  p "There are now #{User.count} users."
  p "There are now #{Program.count} programs."
  p "There are now #{Cohort.count} cohorts."
  p "There are now #{ProgramAdmin.count} program admins."
  p "There are now #{CohortMember.count} cohort members."
  p "There are now #{Match.count} matches."
  p "Done! It took #{(ending - starting).to_i} seconds to create sample data."
end
