CTO::Application.routes.draw do
  resources :ctos
  
  root 'index#index'
 
end
