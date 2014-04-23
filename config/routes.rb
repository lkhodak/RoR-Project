CTO::Application.routes.draw do
  get "services/create"
  resources :ctos do
    resources :services
  end
  
  root 'index#index'
 
end
