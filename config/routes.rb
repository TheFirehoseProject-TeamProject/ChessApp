Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    delete 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  root 'static_pages#index'
  resources :games, only: %i[new create show]
  resources :pieces, only: %i[show update]
end
