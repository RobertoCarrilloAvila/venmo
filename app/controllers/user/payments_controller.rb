class User::PaymentsController < ApplicationController
  include Pagy::Backend

  before_action :set_user, only: [:index, :create]

  def index
    pagy, @payments = pagy(Payment.all_payments(@user))
    @pagy_metadata = pagy_metadata(pagy)
  end

  def create
    PaymentService.call(
      user_id: @user.id,
      **payment_params.to_unsafe_h.symbolize_keys
    )
    head :created
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def payment_params
    params.require(:payment).permit(:friend_id, :amount, :description)
  end
end
