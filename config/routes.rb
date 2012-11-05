Cristal::Application.routes.draw do

  get "home/index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

   resources :people do
        get 'findById', :on => :member
        get 'search', :on => :collection
    end

 
   resources :orgunits  do
       collection do
         get 'search'
       end
     end
     
   resources :projects do
     collection do
       get 'search'
       get 'download'
     end
   end


    resources :fundings  do
      resources :classifications
      collection do
         get 'search'
         get 'download'
      end
     end
    
     # Sample resource route (maps HTTP verbs to controller actions automatically):
    resources :countries 
    resources :sources 
    resources :classifications 
    resources :schemes 


    resources :users do
      resources :sources
      member do
        get 'deleteSource'
        get 'chooseSource'
        put 'addSource'
      end
     end



    resources :sessions, :only => [:new, :create, :destroy]

    match '/activate_user_account',          :to => 'users#activate_account'
    match '/request_new_password',           :to => 'users#request_new_password'
    match '/password_reset',                 :to => 'users#password_reset'
    match '/registration_ok',                :to => 'users#registration_ok'
    match '/generate_and_send_new_password', :to => 'users#generate_and_send_new_password'

    match '/signup',  :to => 'users#new'
    match '/signin',  :to => 'sessions#new'
    match '/signout', :to => 'sessions#destroy'
    match '/person/show/:origid', :to => 'people#findById'
    match '/search',  :to => 'home#search'
    match '/about',  :to => 'home#about'
    match '/faq',  :to => 'home#faq'
    match '/links',  :to => 'home#links'
    match '/contact',  :to => 'home#contact'
    match '/send_contact_msg',  :to => 'home#send_contact_msg'
    match '/contact_msg_sent',  :to => 'home#contact_msg_sent'
    
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
  root :to => "home#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
