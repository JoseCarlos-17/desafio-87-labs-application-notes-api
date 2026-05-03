module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  end

  private

  def record_invalid(error)
    render json: { error: error.message }, status: :unprocessable_entity
  end
end
