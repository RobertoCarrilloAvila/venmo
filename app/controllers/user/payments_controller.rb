class User::PaymentsController < ApplicationController
  before_action :set_user, only: [:index, :create]

  def index
    @payments = Payment.all_payments(@user)
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
