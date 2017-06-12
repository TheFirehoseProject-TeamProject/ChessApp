Rails.application.routes.draw do
  devise_for :users
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'static_pages#index'
  resources :games, only: %i[new create show]
  resources :pieces, only: %i[show update]
end
