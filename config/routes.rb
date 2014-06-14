CTO::Application.routes.draw do
  resources :schedules

  resources :reviews

  get "orders/new"
  get "orders/create"
  get "orders/index"
  devise_for :users
  get "services/create"
  resources :ctos do
    resources :services do
      resources :orders
    end
    resources :schedules
  end
   root 'ctos#index'
 end
