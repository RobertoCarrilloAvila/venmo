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
      friend_id: payment_params[:friend_id],
      amount: payment_params[:amount],
      description: payment_params[:description]
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
