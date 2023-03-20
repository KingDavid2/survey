Rails.application.routes.draw do

  get '/admin', to: 'surveys#index'
  scope :admin do
    devise_for :users
    resources :clients
    resources :surveys do
      resources :questions
      resources :attempts
    end
  end

  root to: "pages#index"

  get ':client_id/:survey_id', to: 'attempts#new', as: :new_attempt_flath
  get ':client_id/:survey_id/:id', to: 'attempts#edit', as: :edit_attempt_flath
  get ':client_id/:survey_id', to: 'attempts#new', as: :new_attempt_flat
  get ':client_id/:survey_id/:id', to: 'attempts#edit', as: :edit_attempt_flat
  patch ':client_id/:survey_id/:id', to: 'attempts#update', as: :patch_attempt_flat

  resources :clients do
    resources :surveys do
      resources :attempts
    end
  end
end
