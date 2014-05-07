CTO::Application.routes.draw do
  get "orders/new"
  get "orders/create"
  devise_for :users
  get "services/create"
  resources :ctos do
    resources :services do
      resources :orders
    end

  end
   root 'ctos#index'
 end
