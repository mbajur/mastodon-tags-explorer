require 'sidekiq/web'

Rails.application.routes.draw do
  if Rails.env.development?
      mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
    end
  post "/graphql", to: "graphql#execute"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Sidekiq::Web => '/sidekiq'

  root to: redirect('tags')

  get :stats, to: 'stats#index'

  resources :tags do
    get :popular, on: :collection
    get :broad, on: :collection
    get :all, on: :collection
  end

  resources :instances, constraints: { id: /.*/ } do
    get :popular, on: :collection
    get :alphabetical, on: :collection
  end

  resources :languages, only: [:index, :show] do
    get :popular, on: :collection
  end
end
