Rails.application.routes.draw do
  
  root 'users#dashboard'
  devise_for :users

  resources :users do
    member do
      get 'repertoire'
      get 'recordings'
      get 'settings'
    end
  end

  resources :tunes, except: [:destroy] do
    resources :sources, :repertoires
  end
  resources :articles
  resources :genres, except: [:destroy]
  resources :jams, only: [:show, :new, :create, :destroy]
  
end

