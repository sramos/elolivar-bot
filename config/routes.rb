Rails.application.routes.draw do
  devise_for :admins
  root to: "home#index" 
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  telegram_webhook TelegramWebhooksController

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
