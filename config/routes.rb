Rails.application.routes.draw do
  namespace :user do
      post ':id/payment', to: 'payments#create', as: :payment
      get ':id/feed', to: 'feeds#index', as: :feed
      get ':id/balance', to: 'balances#show', as: :balance
  end
end
