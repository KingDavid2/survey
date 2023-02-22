Rails.application.routes.draw do

  get '/config', to: 'surveys#index'
  scope :config do
    devise_for :users
    resources :clients
    resources :surveys do
      resources :questions
      resources :attempts
    end
  end

  root to: "pages#index"

  get ':client_id/:survey_id', to: 'attempts#new', as: :new_attempt_flath
  resources :clients do
    resources :surveys do
      resources :attempts
    end
  end
end
