Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    delete 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session_facebook
  end
  root 'static_pages#index'
  resources :pieces, only: %i[update]
  resources :games, only: %i[new create show update] do
    member do
      get :game_available
    end
  end
end


