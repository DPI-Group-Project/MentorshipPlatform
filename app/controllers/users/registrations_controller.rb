# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  after_action :set_csrf_headers, only: :create
  before_action :configure_account_update_params, only: [:update]

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
      redirect_to root_path, alert: "Invalid or expired signup link."
    else
      sign_in(@user) # automatically sign in the user if token is valid
      render 'users/registrations/signup'
    end
  end
  
  def update
    @user = current_user
    if @user.update(account_update_params)
      @user.update(signup_token: nil)
      redirect_to profile_path, notice: "Account updated successfully."
    else
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

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: [:first_name, :last_name, :status, :inactive_reason, :phone_number, :bio, :timezone, :title, :linkedin_link, :profile_picture,
                                             :skills_array, :signup_token, { cohort_members_attributes: %i[role capacity cohort_id] }])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :bio, :skills_array, :linkedin_link, :profile_picture])
  end

  def set_csrf_headers
    return unless request.xhr?

    response.headers['X-CSRF-Token'] = "#{form_authenticity_token}"
    response.headers['X-CSRF-Param'] = "#{request_forgery_protection_token}"
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
