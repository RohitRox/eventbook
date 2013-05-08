Eventbook::Application.routes.draw do
  apipie
  devise_for :users

    # match 'events/:id/survey/new' => 'surveys#new'

  resources :events
  resources :events do
    resource :survey do
      get 'answer', on: :member
      get 'respond_with_mood', on: :member

    end
  end
  # match '/api/events' => 'api#surecompany', :via => [:get]
  resources :users, only: [:show] do
    member do
      get 'edit_profile'
      post 'update_profile'
    end
  end
  namespace :api, defaults: {format: 'json'} do
    namespace :v1, defaults: {format: 'json'}  do
      resources :tokens,:only => [:create, :destroy]
      resources :home,:only => [:index] do
        collection do
          get :get_events
        end
      end
      resources :events do
        member do
          get :cancel_booking
          get :book
          get :geocode
        end
      end
      resources :bookings do
        member do
          get :admit
        end
      end
      resources :users do
        member do
          get :tickets
          get :bookings
        end
        collection do
          get :login
          get :sign_up
        end
      end
    end
  end

  match 'my_events' => 'events#my_events'

  match '/api/v1/users' => 'api/v1/users#options', :constraints => {:method => 'OPTIONS'}
  match '/event_tags' => "events#event_tags"
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
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
  root :to => 'home#index'

  match 'about_us' => 'home#about_us'
  match 'how_it_works' => 'home#how_it_works'
  match 'contact' => 'home#contact'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
