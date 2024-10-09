# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  after_action :set_csrf_headers, only: :create
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    super do |resource|
      if resource.persisted? # Ensure the user is saved successfully
        pp resource.persisted?
        cohort_params = params.require(:user).permit(cohorts_attributes: %i[role cohort_id capacity])

        # Use the association to create the cohort_member
        cohort_member = resource.cohorts.build(
          role: cohort_params[:cohorts_attributes]['0'][:role],
          capacity: cohort_params[:cohorts_attributes]['0'][:capacity],
          cohort_id: cohort_params[:cohorts_attributes]['0'][:cohort_id]
        )

        if cohort_member.save
          Rails.logger.info "CohortMember created: #{cohort_member.inspect}"
        else
          Rails.logger.error "CohortMember creation failed: #{cohort_member.errors.full_messages.join(', ')}"
        end
      end
    end
    return unless resource.errors.any?
    pp resource.persisted?
    Rails.logger.error "User validation errors: #{resource.errors.full_messages.join(', ')}"
  end

  def signup
    @user = User.new
    render 'users/registrations/signup'
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
                                             :skills_array, { cohorts_attributes: %i[role capacity cohort_id] }])
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
