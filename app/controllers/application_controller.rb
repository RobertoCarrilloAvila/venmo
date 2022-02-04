class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid

  private

  def render_record_not_found
    render json: { error: 'Record not found' }, status: :not_found
  end

  def render_record_invalid(exception)
    render json: { errors: exception.record.errors.as_json }, status: :bad_request
  end
end
