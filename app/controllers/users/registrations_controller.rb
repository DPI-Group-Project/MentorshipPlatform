# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  after_action :set_csrf_headers, only: :create

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    super do |resource|
      if resource.persisted?
        Rails.logger.info "User created: #{resource.inspect}"
        if resource.cohort_members.any?
          Rails.logger.info "CohortMember created: #{resource.cohort_members.last.inspect}"
        else
          Rails.logger.error 'CohortMember creation failed'
        end
      end
    end
  end

  def signup
    @user = User.find_by(signup_token: params[:signup_token])

    if @user.nil?
      redirect_to home_path, alert: "Invalid or expired signup link."
    else
      sign_in(@user) # automatically sign in the user if token is valid
      render 'users/registrations/signup'
    end
  end
  
  def update
    @user = User.find(current_user.id)
    Rails.logger.info("Params received: #{account_update_params.inspect}") # Change this line
    
    if @user.update(account_update_params) # Use account_update_params here
      Rails.logger.info("User updated successfully with params: #{account_update_params.inspect}")
    
      @user.update(signup_token: nil)
      redirect_to home_path, notice: "Account updated successfully."
    else
      Rails.logger.error("User update failed: #{@user.errors.full_messages.join(", ")}")
      render :signup, alert: "There was an error updating your account."
    end
  end

  def update_shortlist
    user = current_user
    shortlist = params[:shortlist]
    if user.update!(shortlist: shortlist)
      render json: { message: 'Shortlist updated successfully' }, status: :ok
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: [:first_name, :last_name, :status, :inactive_reason, :phone_number, :bio, :timezone, :title, :linkedin_link, :profile_picture,
                                             :skills_array, :signup_token, { cohort_members_attributes: %i[id capacity] }])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update,
                                        keys: [:first_name, :last_name, :status, :inactive_reason, :phone_number, :bio, :timezone, :title, :linkedin_link, :profile_picture,
                                               :skills_array, { cohort_members_attributes: %i[id capacity] }])
  end

  def set_csrf_headers
    return unless request.xhr?

    response.headers['X-CSRF-Token'] = "#{form_authenticity_token}"
    response.headers['X-CSRF-Param'] = "#{request_forgery_protection_token}"
  end
end
