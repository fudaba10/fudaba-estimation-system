Rails.application.routes.draw do

  get 'menu/index'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  namespace :admin do
    resources :employees
  end

  root to: 'menu#index'

  resources :customers
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
