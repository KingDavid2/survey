Rails.application.routes.draw do

  scope :s do
    get '/:survey_id', to: 'attempts#new'

    # resources :surveys, path: '' do
    #   resources :attempts
    # end
  end

  devise_for :users
  get 'pages/home'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  resources :surveys do
    resources :questions
    resources :attempts
  end
  root to: "pages#index"
end
