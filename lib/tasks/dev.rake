desc 'Fill the database tables with some sample data'
task({ sample_data: :environment }) do
  starting = Time.now
  p "Creating sample data..."

  Cohort.delete_all
  Program.delete_all
  User.delete_all

  admins = []
  people = Array.new(28) do
    {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name
    }
  end

  people << { first_name: 'Alice', last_name: 'Smith' }
  people << { first_name: 'Bob', last_name: 'James' }

  image_name = %w[Buddy Mimi Abby Jack Lily Lucy Jasmine Bear Loki Dusty Maggie Milo Lucky
                  Pepper Baby Boo Sammy Coco Mittens Socks]

  people.each do |person|
    role = { 'Admin' => 10, 'Observer' => 10, 'Mentor' => 40, 'Mentee' => 100 }.find { |_key, value| rand * 100 <= value }.first
    status = { 'Archived' => 10, 'Inactive' => 40, 'Active' => 100 }.find { |_key, value| rand * 100 <= value }.first
    timezone = ['Eastern Standard Time (EST) - UTC-5', 'Central Standard Time (CST) - UTC-6', 'Pacific Standard Time (PST) - UTC-8', 'Mountain Standard Time (MST) - UTC-7'].sample
    mentor_title = ['Software Engineer', 'Consultant', 'Technical Support', 'IT Technician', 'Project Manager', 'Product Manager', 'UI/UX Designer', 'Sales Coordinator'].sample
    inactive_reason = ['Did not like the platform.', 'Did not have a good experience.', 'I will be back!', 'Other'].sample
    image_link = "https://api.dicebear.com/9.x/notionists/svg?seed=#{image_name.sample}&radius=50&backgroundColor=D2042D&bodyIcon=galaxy,
                      saturn,electric&bodyIconProbability=10&gesture=hand,handPhone,ok,okLongArm,point,pointLongArm,waveLongArm&gestureProbability=20&
                      lips=variant01,variant02,variant03,variant04,variant05,variant06,variant07,variant08,variant10,variant11,variant13,
                      variant14,variant15,variant16,variant17,variant18,variant19,variant20,variant21,variant22,variant23,variant24,variant25,
                      variant26,variant27,variant29,variant30"
    skills = ['Java', 'Ruby', 'Python','Communication', 'Networking', 'Organization', 'Leadership', 'Writing']              
    user = User.create(
      email: "#{(person[:first_name]).downcase}@example.com",
      password: 'password',
      first_name: (person[:first_name]).capitalize,
      last_name: (person[:last_name]).capitalize,
      # role: role,
      phone_number: Faker::PhoneNumber.phone_number,
      bio: Faker::Quotes::Shakespeare.hamlet_quote + ' ' + Faker::Quotes::Shakespeare.hamlet_quote,
      timezone: timezone,
      title: role == 'Admin' ? 'Program Organizer' : role == 'Observer' ? 'Observer' : role == 'Mentee' ? 'Trainee' : role == 'Mentor' ? mentor_title : nil,
      linkedin_link: "https://www.linkedin.com/in/#{(person[:first_name]).downcase}-#{(person[:last_name]).downcase}-#{Faker::Number.number(digits: 5)}/",
      profile_picture: image_link,
      status: status,
      inactive_reason: status == 'Inactive' ? inactive_reason : nil,
      skills_array: [skills.sample, skills.sample]
    )

    if role == 'Admin'
      admins << user
    end
  end

  program_names = ['Software Development', 'Teacher Training', 'Apprenticeship']
  program_index = 0

  admins.each do |admin|
    program_passcode = Faker::Number.number(digits: 8).to_s
    if program_index < program_names.length
      program = Program.create(
        name: program_names[program_index],
        description: "This program is for the #{program_names[program_index]} DPI program",
        creator_id: admin.id,
        contact_id: admin.id,
        passcode: program_passcode,
        # required_meetings: [6, 10].sample
      )
    end
    program_index += 1
  end

  Program.all.each do |program|
    cohort_random_number = rand(1..3)
    count = 1
    cohort_random_number.times do
      start_date = Faker::Date.between(from: '2022-01-1', to: '2023-12-30')
      cohort = Cohort.create(
        cohort_name: "Cohort #{count}",
        description: "This cohort is part of the #{program.name} program",
        program_id: program.id,
        creator_id: program.creator_id,
        contact_id: program.creator_id,
        start_date: start_date,
        end_date: Faker::Date.between(from: start_date, to: '2024-12-30'),
        # required_meetings: [6, 10].sample
      )
      count += 1
    end
  end

  ending = Time.now
  p "There are now #{User.count} users."
  p "There are now #{Program.count} programs."
  p "There are now #{Cohort.count} cohorts."
  p "Done! It took #{(ending - starting).to_i} seconds to create sample data."
end