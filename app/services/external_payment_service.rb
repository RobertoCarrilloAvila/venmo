class ExternalPaymentService < ApplicationService
  DESCRIPTION = 'Payment from external service'
  ORIGIN_ID = 0

  attr_reader :user_id, :friend_id, :amount, :description

  def initialize(user_id:, amount:)
    @user_id = user_id
    @amount  = amount
  end

  def call
    transfer_balance
  end

  private

  def transfer_balance
    ActiveRecord::Base.transaction do
      user.deposit(amount)

      Payment.create(
        origin_id: user.id,
        target_id: user.id,
        amount: amount,
        description: DESCRIPTION
      )
    end
  end

  def user
    @user ||= User.find(user_id)
  end
end