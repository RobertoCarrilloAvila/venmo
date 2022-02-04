class PaymentService < ApplicationService
  attr_reader :user_id, :friend_id, :amount, :description

  def initialize(user_id:, friend_id:, amount:, description:)
    @user_id     = user_id
    @friend_id   = friend_id
    @amount      = amount
    @description = description
  end

  def call
    transfer_balance
  end

  private

  def transfer_balance
    # transfer balance from origin to target
    if origin.balance.zero? || origin.balance.negative?
      external_payment
      origin.reload
    end

    send_money
  end

  def send_money
    ActiveRecord::Base.transaction do
      origin.withdraw(amount)
      target.deposit(amount)

      Payment.create!(
        origin: origin,
        target: target,
        amount: amount,
        description: description
      )
    end
  end

  def external_payment
    ExternalPaymentService.call(user_id: origin.id, amount: amount)
  end

  def origin
    @origin ||= User.find(user_id)
  end

  def target
    @target ||= origin.friends.find(friend_id)
  end
end
