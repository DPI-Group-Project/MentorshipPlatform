# app/helpers/dashboard_helper.rb
module DashboardHelper
  def progress_message(progress)
    case progress
    when 0
      "You’ve taken the first step! Excited for the journey ahead. 🎉"
    when 1..15
      "Keep going! The journey has just begun. 🚶‍♂️"
    when 16..32
      "Great start! You’ve crossed the first milestone. 👍"
    when 33..49
      "You’re moving smoothly! Already a third of the way there. 🚀"
    when 50..65
      "Halfway through! Getting here is an achievement itself. 💪"
    when 66..82
      "Almost there! The finish line is in sight. 👀"
    when 83..99
      "The final step is just around the corner! Keep going! 🌟"
    when 100
      "You’ve completed the entire journey! Congratulations on a job well done! 🎊👏"
    else
      "Let's keep pushing forward! Every step counts. 🌈"
    end
  end
end
