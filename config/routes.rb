Rails.application.routes.draw do
  mount MissionControl::Jobs::Engine, at: "/jobs"

  # Messages
  resources :messages, only: [ :create ]

  # Chats
  resources :chats, only: [ :index, :show, :create ]

  # Chatbots
  resources :chatbots, only: [ :index, :new, :create, :update ]

  resources :chatbots do
    resource :settings, only: [ :show, :update, :destroy ], controller: "chatbots/settings"
    resource :sources, only: [ :show, :update, :destroy ], controller: "chatbots/sources"
    resource :integrations, only: [ :show ], controller: "chatbots/integrations" do
      resource :waba, only: [ :edit, :update ], controller: "chatbots/integrations/wabas" do
        post :subscribe
        post :unsubscribe
      end
    end
    resource :playground, only: [ :show, :update ], controller: "chatbots/playground"
  end

  # Whatsapp Integration
  resources :wabas, only: [ :create, :edit ]
  post "/wabas/exchange_token_and_subscribe_app", to: "wabas#exchange_token_and_subscribe_app"

  # Devise
  devise_for :users

  # Webhooks
  resources :webhooks, only: [ :index, :create ]

  # Dashboard
  get "/dashboard", to: "dashboard#index"

  # Checkout
  get "/subscriptions", to: "subscriptions#show"
  get "/subscriptions/success", to: "subscriptions#success"
  get "/subscriptions/cancel", to: "subscriptions#cancel"
  # get "billing", to: "billing#show"
  # TODO: Add cancel route

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
