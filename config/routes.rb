RaidsPerLoot::Application.routes.draw do

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
      get :statistics
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

  resource :session, :only => [:new, :create, :destroy]

  match 'signup' => 'users#new', :as => :signup
  match 'register' => 'users#create', :as => :register
  match 'login' => 'sessions#new', :as => :login
  match 'logout' => 'sessions#destroy', :as => :logout
  match '/activate/:activation_code' => 'users#activate', :as => :activate, :activation_code => nil

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

  #namespace :admin do
  #  constraints CanAccessResque do
  #    mount Resque::Server, at: 'resque'
  #  end
  #end

  #resources :users do
  #  member do
  #    put :suspend
  #    put :unsuspend
  #    delete :purge
  #  end
  #end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'
  root :to => 'viewer#show', :name => 'home'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.

  #match ':controller(/:action(/:id(.:format)))'
end
