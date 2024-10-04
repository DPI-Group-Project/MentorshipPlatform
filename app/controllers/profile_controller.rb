class ProfileController < ApplicationController
  before_action :profile_params, only: [:show]
  def show
    @user = User.where(id: params[:id])
  end

  private
  # Only allow a list of trusted parameters through.
  def profile_params
    params.permit(:id)
  end
end