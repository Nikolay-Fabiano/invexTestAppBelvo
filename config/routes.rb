Rails.application.routes.draw do
  root 'static_pages#index'

  get 'account/:id', to: 'static_pages#single_account', as: 'single_account'
  get 'dashboard', to: 'static_pages#dashboard'
end
