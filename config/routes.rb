Rails.application.routes.draw do
  mount MissionControl::Jobs::Engine, at: "/jobs"

  # Messages
  resources :messages, only: [ :create ]

  # Chats
  resources :chats, only: [ :index, :show, :create ]

  # Chatbots
  resources :chatbots, only: [ :index, :new, :create ]
  namespace :chatbots do
    resources :playground, param: :chatbot_id, only: [ :edit, :update ]
    resources :settings, param: :chatbot_id, only: [ :show, :update, :destroy ]
    resources :integrations, param: :chatbot_id, only: [ :show ]
  end

  # Whatsapp Integration
  resources :wa_integrations, only: [ :create ]
  post "/wa_integrations/exchange_token_and_subscribe_app", to: "wa_integrations#exchange_token_and_subscribe_app"

  # Devise
  devise_for :users

  # Webhooks
  resources :webhooks, only: [ :index, :create ]

  # Dashboard
  get "/dashboard", to: "dashboard#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
end
