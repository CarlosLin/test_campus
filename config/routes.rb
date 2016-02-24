Rails.application.routes.draw do
  mount Bootsy::Engine => '/bootsy', as: 'bootsy'
  namespace :admin do
    resources :posts
  end
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  resources :posts do
    resources :messages, only: [:create]
    resources :favorites, only: [:create, :destroy]
  end
  get '/index' => 'posts#index_all', :as => "index_all"
  resources :users, only: [:show]
  get '/info' => 'users#info', :as => "user_infos"
  get '/historys' => 'users#history', :as => "historys"
  root 'posts#index'
end
