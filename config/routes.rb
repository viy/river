Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
   root 'rivers#index'

  resources :rivers do
    member do
      post :match
    end

    collection do
      post :import
      get :export
      get :list
    end
  end
end
