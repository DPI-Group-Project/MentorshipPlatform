# app/helpers/dashboard_helper.rb
module DashboardHelper
  def progress_message_helper(progress, messages)
    messages.each { |range, message| return message if range === progress }
    "Let’s keep pushing forward! Every step counts. ☀"
  end

  def mentor_progress_messages
    {
      0 => "Your guidance starts here—let’s make a difference together! ✨",
      1..9 => "You’ve helped your mentee start strong—great work! 👌",
      10..19 => "Your support is driving progress—keep it up! 🚤",
      20..29 => "A third of the way there—your impact is showing! 🚀",
      30..39 => "Your mentorship is guiding the way—amazing effort! ✨",
      40..49 => "Halfway through—your dedication is making this possible! 💪",
      50..59 => "Your mentee is thriving, thanks to your support—fantastic work! 🤝",
      60..69 => "You’re empowering success—almost there! 🏆",
      70..79 => "Your mentorship is fueling incredible progress—keep going! 🔑",
      80..89 => "The finish line is near—your guidance has been invaluable! ☀",
      90..99 => "You’ve helped your mentee achieve greatness—congratulations! 🎉👏",
    }
  end

  def mentee_progress_messages
    {
      0 => "You’ve taken the first step! Excited for the journey ahead. 🎉",
      1..15 => "Keep going! The journey has just begun. 👨‍⛶",
      16..32 => "Great start! You’ve crossed the first milestone. 👍",
      33..49 => "You’re moving smoothly! Already a third of the way there. 🚀",
      50..65 => "Halfway through! Getting here is an achievement itself. 💪",
      66..82 => "Almost there! The finish line is in sight. 👁",
      83..99 => "The final step is just around the corner! Keep going! ✨",
      100 => "You’ve completed the entire journey! Congratulations on a job well done! 🎊👏",
    }
  end
end
