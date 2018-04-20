require 'sidekiq/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Sidekiq::Web => '/sidekiq'

  root to: 'tags#index'

  get :stats, to: 'stats#index'

  resources :tags do
    get :popular, on: :collection
    get :broad, on: :collection
    get :all, on: :collection
  end

  resources :instances, constraints: { id: /.*/ } do
    get :alphabetical, on: :collection
  end
end
