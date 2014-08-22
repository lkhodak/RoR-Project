CTO::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :schedules

  resources :reviews

  get "orders/new"
  get "orders/create"
  get "orders/index"
  devise_for :users
  get "services/create"
  resources :ctos do
    resources :services
    resources :orders
    resources :schedules
  end
  root 'ctos#index'
end
