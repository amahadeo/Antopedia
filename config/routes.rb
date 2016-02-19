Rails.application.routes.draw do
  

  resource :charges, only: [:new, :create, :edit, :destroy]
  resources :wikis do
    resources :users, only: [] do 
      resource :collaborators, only: [:create, :destroy]
    end
  end
  
  resources :wikis, only: [] do
    resources :collaborators, only: [:index]
  end

  devise_for :users
  root to: 'welcome#index'

end