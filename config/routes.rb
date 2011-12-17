RaidsPerLoot::Application.routes.draw do

  resources :mobs
  resources :items
  resources :players do
    collection do
      get :raids
    end
  end

  resources :raids do
    collection do
      get :players
    end
    member do
      put :add_player
    end
  end

  resources :zones do
    collection do
      get :raids
    end
  end

  resources :archetypes
  resources :pages
  resources :users
  resources :loot_types
  resources :ranks
  resources :slots
  resources :link_categories

  resources :links do
    collection do
      get :list
    end
  end

  resources :drops do
    member do
      get :assign_loot
      get :unassign_loot
    end
  end

  match '/upload_drop' => 'drops#upload', :as => :upload_drop

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

  #  match '/view_page/:name', :controller => 'viewer', :action => 'show'
  match ':name' => 'viewer#show', :as => :view_page

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'
  root :to => 'viewer#show', :name => 'home'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.

  match ':controller(/:action(/:id(.:format)))'
end
