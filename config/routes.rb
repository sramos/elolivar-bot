Rails.application.routes.draw do
  devise_for :admins
  root to: "home#index" 
  match 'calendar/:day/:type', controller: :calendar, action: :menu, via: :get, as: 'daily_menu'
  match 'calendar', controller: :calendar, action: :index, via: [:get], as: 'calendar'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  telegram_webhook TelegramWebhooksController

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
