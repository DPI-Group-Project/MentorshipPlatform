require "rufus-scheduler"

class Scheduler
  @scheduler = Rufus::Scheduler.singleton

  class << self
    def at(time, &block)
      @scheduler.at(time, &block)
    end
  end
end
