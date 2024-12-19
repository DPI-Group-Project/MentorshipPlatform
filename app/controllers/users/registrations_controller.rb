# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params, only: [:create]
    after_action :set_csrf_headers, only: :create
    before_action :configure_account_update_params, only: [:update]

    # POST /resource
    def create
      super do |resource|
        if resource.persisted?
          Rails.logger.info "User created: #{resource.inspect}"
          if resource.cohort_member.any?
            Rails.logger.info "CohortMember created: #{resource.cohort_members.last.inspect}"
          else
            Rails.logger.error "CohortMember creation failed"
          end
        end
      end
    end

    def signup
      @user = User.new
      @skills = %w[Java Ruby Python Communication Networking Organization Leadership Writing]
      render "users/registrations/signup"
    end

    def update_shortlist
      user = current_user
      cohort_id = current_user.cohort.id
      shortlist_data = params[:shortlist]

      # Clear the user's previous shortlist before updating
      ShortList.where(mentee_id: user.id).delete_all

      shortlist_data.each_with_index do |mentor_id, index|
        ShortList.create!(
          mentor: User.find(mentor_id),
          mentee: user,
          cohort: Cohort.find(cohort_id),
          ranking: index + 1
        )
      end

      flash[:notice] = "Shortlist has been updated successfully."
      render json: { message: "Shortlist updated successfully" }, status: :ok
    rescue ActiveRecord::RecordInvalid => e
      flash[:alert] = "Failed to update shortlist. Please try again."
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    end

    protected

    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: sign_up_keys)
    end

    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: account_update_keys)
    end

    def set_csrf_headers
      return unless request.xhr?

      response.headers["X-CSRF-Token"] = form_authenticity_token.to_s
      response.headers["X-CSRF-Param"] = request_forgery_protection_token.to_s
    end

    private

    def sign_up_keys
      [
        :first_name, :last_name, :status, :inactive_reason, :phone_number, :bio,
        :timezone, :title, :linkedin_link, :profile_picture, { skills_array: [] },
        { cohort_members_attributes: %i[role capacity cohort_id] }
      ]
    end

    def account_update_keys
      %i[first_name last_name status inactive_reason phone_number bio timezone title linkedin_link profile_picture skills_array]
    end
  end
end
