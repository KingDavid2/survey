Rails.application.routes.draw do
  get 'pages/home'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  resources :surveys do
    resources :questions
    resources :attempts
  end
  root to: "surveys#index"
end
