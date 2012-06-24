RaidsPerLoot::Application.routes.draw do

  resources :adjustments

  resources :character_types

  resources :characters do
    resources :character_types
    resources :adjustments
    resources :drops
    member do
      get :info
      get :fetch_data
    end
    collection do
      get :option_list
      get :fetch_all_data
      get :statistics
    end
  end

  resources :difficulties

  resources :raids do
    resources :instances
  end

  resources :instances do
    resources :drops
    resources :players
    resources :characters
    member do
      put :add_player
      get :player_list
    end
  end

  resources :zones do
    resources :instances
    resources :mobs
    resources :drops
    member do
      put :add_mob
      get :mob_list
    end
  end

  resources :mobs do
    resources :drops
  end
  resources :items do
    resources :drops
    resources :archetypes
    member do
      get :info
      get :fetch_data
    end
    collection do
      get :fetch_all_data
    end
  end

  resources :players do
    resources :instances
    resources :drops
    resources :characters
    resources :adjustments
    collection do
      get :option_list
    end
  end

  resources :archetypes do
    resources :players
    resources :items
  end
  resources :ranks do
    resources :players
  end
  resources :loot_types do
    resources :items
  end
  resources :slots do
    resources :items
  end

  resources :drops do
    resources :instances
    resources :players
    collection do
      put :upload_drop
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
  get '/admin/update_character_list', :controller => 'admin', :action => 'update_character_list'

  match ':name' => 'viewer#show', :as => :view_page
  post '/viewer/set_page_body/:id', :controller => 'viewer', :action => 'set_page_body'
  get '/viewer/get_unformatted_text/:id', :controller => 'viewer', :action => 'get_unformatted_text'

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
