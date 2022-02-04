class User::PaymentsController < ApplicationController
  before_action :set_user, only: [:index]

  def index
    @payments = Payment.all_payments(@user)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
