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
        if resource.cohort_member.any?
          Rails.logger.info "CohortMember created: #{resource.cohort_members.last.inspect}"
        else
          Rails.logger.error 'CohortMember creation failed'
        end
      end
    end
  end

  def signup
    @user = User.new
    @skills = ["Java", "Ruby", "Python", "Communication", "Networking", "Organization", "Leadership", "Writing"]
    render 'users/registrations/signup'
  end

  def update_shortlist
    user = current_user
    cohort_id = current_user.cohort.id
    shortlist_data = params[:shortlist]

    # Clear the user's previous shortlist before updating
    ShortList.where(mentee_id: user.id).delete_all

    # Iterate over the array and create entries with rankings based on index
    shortlist_data.each_with_index do |mentor_id, index|
      ShortList.create!(
        mentor: User.find(mentor_id),
        mentee: user,
        cohort: Cohort.find(cohort_id),
        ranking: index + 1
      )
    end

    flash[:notice] = 'Shortlist has been updated successfully.'
    render json: { message: 'Shortlist updated successfully' }, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    flash[:alert] = 'Failed to update shortlist. Please try again.'
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
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
                                      keys: [:first_name, :last_name, :status, :inactive_reason, :phone_number, 
                                             :bio, :timezone, :title, :linkedin_link, :profile_picture, 
                                             { skills_array: [] },
                                             cohort_members_attributes: %i[role capacity cohort_id]])
  end
  


  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: [:first_name, :last_name, :status, :inactive_reason, :phone_number, :bio, :timezone, :title, :linkedin_link, :profile_picture,
                                             :skills_array])
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
