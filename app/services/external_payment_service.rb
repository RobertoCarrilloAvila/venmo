class ExternalPaymentService < ApplicationService
  DESCRIPTION = 'Payment from external service'.freeze
  ORIGIN_ID = 0

  attr_reader :user, :friend_id, :amount, :description

  def initialize(user:, amount:)
    @user = user
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
end
