class ProfileController < ApplicationController
  before_action :profile_params, only: [:show]
  before_action :set_profile_user, only: [:show, :create]  
  
  def show
  end

  def create 
    user2 = User.all.sample  #temporary test current_user
    Match.create(mentor_id: @user.id, mentee_id: user2.id,
                cohort_id: user2.cohorts.first.id, active: true)

    # TODO: Create capacity increment
    
    # TODO: Check to see if @users capacity has been reached
    # Avalible column in users for mentors???

    respond_to do |format|
      if @message.save
        format.html { redirect_to "/profile/#{@user.id}", notice: 'Message was successfully created.' }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def set_profile_user
    @user = User.where(id: params[:id])
  end
  # Only allow a list of trusted parameters through.
  def profile_params
    params.permit(:id)
  end
end