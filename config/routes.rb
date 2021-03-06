Rails.application.routes.draw do

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  namespace :admin do
    resources :employees
  end

  root to: 'menu#index'

  resources :customers
  resources :vendors
  resources :estimates

end
