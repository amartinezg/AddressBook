module ExceptionHandler

  extend ActiveSupport::Concern

  included do
    rescue_from Exception do |e|
      message = Rails.env.production? ? "There was a problem with the server" : "#{e.class} - #{e.message} - #{e.backtrace}"
      render json: {message: message}, status: :internal_server_error
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: {message: "Organization does not exist"}, status: :not_found
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      render json: {message: e.message}, status: :unprocessable_entity
    end

    rescue_from CanCan::AccessDenied do |e|
      render json: {message: e.message}, status: :forbidden
    end

    rescue_from ::FirebaseWrapper::RecordNotFound do |e|
      render json: {message: e.message}, status: :not_found
    end

    rescue_from ::FirebaseWrapper::StandardError do |e|
      render json: {message: e.message}, status: :unprocessable_entity
    end
  end
end
