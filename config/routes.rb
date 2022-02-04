Rails.application.routes.draw do
  defaults format: :json do
    namespace :user do
      post ':id/payment', to: 'payments#create', as: :payment
      get ':id/feed', to: 'payments#index', as: :feed
      get ':id/balance', to: 'balances#show', as: :balance
    end
  end
end
