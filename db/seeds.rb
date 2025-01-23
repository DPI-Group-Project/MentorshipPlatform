User.create(
  email: "nathan@example.com",
  password: "password",
  first_name: "Nathan",
  last_name: "Wells"
)

Program.create(
  name: "Major Tom to Ground Control",
  contact_id: User.find_by(email: "nathan@example.com").id
)

ProgramAdmin.create(
  user_id: User.find_by(email: "nathan@example.com").id,
  program_id: Program.find_by(name: "Major Tom to Ground Control").id
)
