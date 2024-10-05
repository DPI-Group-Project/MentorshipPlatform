class ProfileController < ApplicationController
  before_action :profile_params, only: [:show]
  before_action :set_profile_user, only: [:show, :create]  
  
  def show
  end

  def create 
    @current_mentee_count = @user.mentee_capacity_count(user2.cohort.first.id)
    @capacity_cap = @user.capacity

    if @current_mentee_count < @capacity_cap
      user2 = User.all.sample  #temporary test current_user
      Match.create(mentor_id: @user.id, mentee_id: user2.id,
                cohort_id: user2.cohort, active: true)
    end

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