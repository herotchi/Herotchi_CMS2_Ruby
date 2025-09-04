Rails.application.routes.draw do
  get "top/index"
  root "top#index"
  devise_for :users, controllers: {
    registrations: "users/registrations",
    passwords: "users/passwords",
    sessions: "users/sessions",
    confirmations: "users/confirmations"
  }

  resources :contacts, only: [ :new, :create ] do
    collection do
      post "confirm"
      get "complete"
    end
  end

  namespace :admin do
    root "top#index"
    devise_for :managers, controllers: {
        sessions:       "admin/managers/sessions",
        registrations:  "admin/managers/registrations"
    }
    resources :news
    resources :first_categories
    resources :second_categories
    resources :tags
    resources :products
    resources :media
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
