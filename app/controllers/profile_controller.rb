class ProfileController < ApplicationController
  before_action :profile_params, only: [:show]
  before_action :set_profile_user, only: [:show, :create]  
  
  def show
  end

  def create 
    @current_mentee_count = @user.mentee_capacity_count(user2.cohort.first.id)
    @capacity_cap = @user.capacity

    respond_to do |format|
      if @current_mentee_count < @capacity_cap
        user2 = User.where.not(id: @user.id).sample  #temporary test current_user
        match = Match.create(mentor_id: @user.id, mentee_id: user2.id, cohort_id: user2.cohort, active: true)

        #TODO: Update mentee dashboard
        #if capacity is reached remove mentor form list of mentors on dashboard
        #
        if match.save
          format.html { redirect_to "/profile/#{@user.id}", notice: 'You are now matched!' }
          format.json { render :show, status: :created, location: @message }
        else
          format.html { redirect_to "/profile/#{@user.id}", alert: 'Error has occurred. Not matched' }
          format.json { head :no_content }
        end
      else
        format.html { redirect_to "/profile/#{@user.id}", alert: 'Sorry, this mentor has reached their intake capacity. Try a different mentor.' }
        format.json { head :no_content }
      end
    end
  end

  private
  def set_profile_user
    @user = User.find(id: params[:id])
  end
  # Only allow a list of trusted parameters through.
  def profile_params
    params.permit(:id)
  end
end