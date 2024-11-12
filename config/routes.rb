Rails.application.routes.draw do
  root to: "home#index"

  resource :session
  resources :passwords, param: :token

  get "/dashboard", to: "home#dashboard"
end
