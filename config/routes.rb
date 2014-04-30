CTO::Application.routes.draw do
  devise_for :users
  get "services/create"
  resources :ctos do
    resources :services
  end
  
  root 'ctos#index'
 
end
