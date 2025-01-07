class HomeController < ApplicationController
  def index; end

  def mentorship
    render "home/about_mentorship"
  end
end
