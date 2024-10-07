class ProfileController < ApplicationController
  before_action :profile_params, only: [:show]
  before_action :set_profile_user, only: [:show, :create]  
  before_action :set_capacity_info, only: [:show, :create]  
  
  def show
    @role = @user.first.role
  end

  def create 
    p 'IN CREATE ACTION'

    respond_to do |format|
      if @current_mentee_count < @capacity_cap
        match = Match.create(mentor_id: @user.first.id, mentee_id: @current_user.id, cohort_id: @current_user.cohort, active: true)

        #TODO: Update mentee dashboard
        #if capacity is reached remove mentor from list of mentors on dashboard
        #if mentee is already matched dont show match button

        
        if match.save
          format.html { redirect_to "/profile/#{@user.first.id}", notice: 'You are now matched!' }
          format.json { render :show, status: :created, location: @message }
          format.js
        else
          format.html { redirect_to "/profile/#{@user.first.id}", alert: 'Error has occurred. Not matched' }
          format.json { head :no_content }
        end
      else
        format.html { redirect_to "/profile/#{@user.first.id}", alert: 'Sorry, this mentor has reached their intake capacity. Try a different mentor.' }
        format.json { head :no_content }
      end
    end
  end

  private
  def set_capacity_info
    @current_mentee_count = @user.first.mentee_capacity_count(@user.first.cohort)
    @capacity_cap = @user.first.capacity
  end
  def set_profile_user
    @user = User.where(id: params[:id])
    @current_user = User.mentees_in_cohort(@user.first.cohort).sample #temporary test current_user
  end
  # Only allow a list of trusted parameters through.
  def profile_params
    params.permit(:id)
  end
end