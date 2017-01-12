require 'api_constraints'

Rails.application.routes.draw do
  # Api definition
  namespace :api, defaults: { format: :json }, path: '/'  do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      # We are going to list our resources here
      resources :users, only: [:show, :create, :update, :destroy] do
        resources :events, only: [:show, :create, :update, :destroy] do
          match 'location', to: 'locations#update_user_location_with_response', via: :put
        end
        get 'events', to: 'events#index', as: :all_events
        get 'hosts', to: 'events#hosting', as: :hosts
        get 'attends', to: 'events#attending', as: :attends
        get 'invites', to: 'events#invited', as: :invites

        get 'location', to: 'locations#show_user_location', as: :location
        match 'location', to: 'locations#create_user_location', via: :post
        match 'location', to: 'locations#update_user_location', via: :put
      end
      resources :sessions, only: [:create, :destroy]
      resources :events, only: [] do
        get 'location', to: 'locations#show_event_location', as: :location
        get 'users/location', to: 'locations#show_location_of_users_for_event', as: :users_location
      end
    end
  end
  devise_for :users
end
