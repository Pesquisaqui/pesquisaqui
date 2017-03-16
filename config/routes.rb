Rails.application.routes.draw do
  root to: "topics#index"
  resources :topics
  resources :users, only: [:index]
  devise_for :users
  resources :users, only: [:show]

  devise_scope :user do
    get 'login', to: 'devise/sessions#new'
  end

  devise_scope :user do
    get 'logout', to: 'devise/sessions#destroy'
  end

  devise_scope :user do
    get 'me', to: 'devise/registrations#edit'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
