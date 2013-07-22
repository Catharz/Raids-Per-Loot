RaidsPerLoot::Application.routes.draw do

  # Audit Trail
  get '/versions/index'

  # Omniauth pure
  match "/signin" => "services#signin"
  match "/signout" => "services#signout"

  match '/auth/:service/callback' => 'services#create'
  match '/auth/failure' => 'services#failure'

  resources :services, :only => [:index, :create, :destroy] do
    collection do
      get 'signin'
      get 'signout'
      get 'signup'
      post 'newaccount'
      get 'failure'
    end
  end

  resources :comments

  resources :raid_types

  resources :raids do
    resources :instances
  end
  resources :instances do
    resources :players, :characters, :drops
    collection do
      get :option_list
    end
  end

  resources :difficulties
  resources :zones do
    resources :mobs, :instances, :drops
    member do
      get :mob_list
    end
    collection do
      get :option_list
    end
  end
  resources :mobs do
    resources :drops
    collection do
      get :option_list
    end
  end

  resources :ranks do
    resources :players
  end
  resources :players do
    resources :characters, :instances, :drops, :adjustments
    collection do
      get :option_list
      get :attendance
    end
  end
  resources :player_raids

  resources :archetypes do
    resources :characters, :items
  end
  resources :character_types
  resources :character_instances
  resources :characters do
    resources :character_types, :adjustments, :drops
    member do
      get :info
      post :fetch_data
      post :update_data
    end
    collection do
      get :loot
      get :option_list
      get :statistics
      get :attendance
    end
  end

  resources :adjustments

  resources :loot_types do
    resources :items
  end
  resources :slots do
    resources :items
  end
  resources :items do
    resources :drops, :archetypes
    member do
      get :info
      post :fetch_data
    end
    collection do
      post :fetch_all_data
    end
  end
  resources :drops do
    resources :instances, :players
    collection do
      get :invalid
    end
  end

  resources :users
  resources :pages
  resources :link_categories
  resources :links do
    collection do
      get :list
    end
  end

  get '/statistics/guild_achievements', controller: 'statistics', action: 'guild_achievements'

  match 'signup' => 'users#new', :as => :signup
  match 'register' => 'users#create', :as => :register

  resource :session, :only => [:new, :destroy]
  match "/auth/:provider/callback" => 'sessions#create'

  get "pages/home"
  get "pages/resources"
  get "pages/about"
  get "pages/contact"

  get '/admin', :controller => 'admin', :action => 'show'
  post '/admin/update_player_list', :controller => 'admin', :action => 'update_player_list'
  post '/admin/update_character_list', :controller => 'admin', :action => 'update_character_list'
  post '/admin/update_character_details', :controller => 'admin', :action => 'update_character_details'
  post '/admin/resolve_duplicate_items', :controller => 'admin', :action => 'resolve_duplicate_items'
  post '/admin/fix_trash_drops', :controller => 'admin', :action => 'fix_trash_drops'

  match ':name' => 'viewer#show', :as => :view_page
  post '/viewer/set_page_body/:id', :controller => 'viewer', :action => 'set_page_body'
  get '/viewer/get_unformatted_text/:id', :controller => 'viewer', :action => 'get_unformatted_text'

  root :to => 'viewer#show', :name => 'home'
end
