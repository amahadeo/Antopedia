Rails.application.routes.draw do
  
  
  resource :charges, only: [:new, :create, :edit, :destroy]
  resources :wikis

  devise_for :users
  root to: 'welcome#index'

end