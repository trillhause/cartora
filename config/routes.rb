require 'api_constraints'

Rails.application.routes.draw do
  # Api definition
  namespace :api, defaults: { format: :json }, path: '/'  do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      # We are going to list our resources here
      resources :users, only: [:show, :create, :update, :destroy] do
        resources :events, only: [:create, :update, :destroy, :show]
        get '/users/:user_id/events', to: 'events#index', as: :all_events
        get '/users/:user_id/hosts', to: 'events#hosting', as: :hosts
        get '/users/:user_id/attends', to: 'events#attending', as: :attends
        get '/users/:user_id/invites', to: 'events#invited', as: :invites
      end
      resources :sessions, only: [:create, :destroy]

    end
  end
  devise_for :users
end
