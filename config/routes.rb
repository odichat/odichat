Rails.application.routes.draw do
  authenticate :user, ->(u) { u.admin? } do
    mount_avo at: "/admin"
  end
  mount MissionControl::Jobs::Engine, at: "/jobs"

  # Messages
  resources :messages, only: [ :create ]

  # Chatbots
  resources :chatbots, only: [ :index, :new, :create, :update ]

  resources :chatbots do
    resources :products, controller: "chatbots/products"
    resources :responses, controller: "chatbots/responses"
    resources :documents, controller: "chatbots/documents"
    resource :playground, only: [ :show, :update ], controller: "chatbots/playground"
    resources :chats, only: [ :create ], controller: "chatbots/chats"
    resources :conversations, controller: "chatbots/conversations" do
      post :intervene, on: :member
    end
    resource :sources, only: [ :show, :update, :destroy ], controller: "chatbots/sources"
    resource :settings, only: [ :show, :update, :destroy ], controller: "chatbots/settings"
    resource :integrations, only: [ :show ], controller: "chatbots/integrations" do
      resource :whatsapp, only: [ :edit, :update ], controller: "chatbots/integrations/whatsapp" do
        post :subscribe
        post :unsubscribe
      end
    end
    # get "contacts/:contact_id/conversation", to: "chatbots/conversations#show", as: :contact_conversation
  end

  # Whatsapp Integration
  resources :wabas, only: [ :create ] do
    collection do
      post :exchange_token_and_subscribe_app
    end
  end

  post "whatsapp", to: "whatsapp#create"
  post "whatsapp/exchange_token_and_subscribe_app", to: "whatsapp#exchange_token_and_subscribe_app"

  # Devise
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }

  # Webhooks
  namespace :webhooks do
    get "whatsapp/process_payload", to: "whatsapp#verify"
    post "whatsapp/process_payload", to: "whatsapp#process_payload"
  end

  # Checkout
  get "/subscriptions/billing", to: "subscriptions#show"
  get "/subscriptions/pricing", to: "subscriptions#index"
  get "/subscriptions/checkout", to: "subscriptions#checkout"
  get "/subscriptions/success", to: "subscriptions#success"
  get "/subscriptions/cancel", to: "subscriptions#cancel"

  namespace :public do
    get "chats/create"
    resources :messages, only: [ :create ]
    resources :chats, only: [ :create ]
  end
  get "public/playground/:token", to: "public/playground#show", as: :public_playground

  resources :support_tickets, only: [ :new, :create ], path: "support"

  # Wicked
  resources :after_signup

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
