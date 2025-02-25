class ProfileController < ApplicationController
  before_action :profile_params, only: [:show]
  before_action :set_profile_user, only: %i[show create]
  before_action :set_capacity_info, only: %i[show create]

  def show
    @role = @user.role
  end

  def create
    Rails.logger.debug "IN CREATE ACTION"

    respond_to do |format|
      if @current_mentee_count < @capacity_cap && current_user.matched? == false
        match = Match.create(mentor_id: @user.id, mentee_id: current_user.id, cohort_id: current_user.cohort.id,
                             active: true)

        if match.save
          format.html { redirect_to "/profile/#{@user.id}", notice: "You are now matched!" }
          format.json { render :show, status: :created, location: @message }
          format.js
        else
          format.html { redirect_to "/profile/#{@user.id}", alert: "Error has occurred. Not matched" }
          format.json { head :no_content }
        end
      else
        format.html do
          redirect_to "/profile/#{@user.id}",
                      alert: "Sorry, this mentor has reached their intake capacity. Try a different mentor."
        end
        format.json { head :no_content }
      end
    end
  end

  private

  def set_capacity_info
    @current_mentee_count = @user.mentee_capacity_count(@user.cohort.id)
    @capacity_cap = @user.capacity
  end

  def set_profile_user
    @user = User.find_by(id: params[:id])
  end

  # Only allow a list of trusted parameters through.
  def profile_params
    params.permit(:id)
  end
end
