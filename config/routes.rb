Eve::Application.routes.draw do |map|
  root :to => "welcome#home"

  get "faq", :to => 'static#faq'
  get "contact", :to => 'static#contact'
  get "copyright", :to => 'static#copyright'

  get "debug/dump"
  get "debug/exception"

  get "item_comparison", :to => 'tools#compare_items'
  get "tools/fetch_children"
  post "tools/add_or_remove"

  get "ore_value", :to => 'mining#ore_value'
  post "mining/save_prices"
  
  # old URL redirection
  get "static/faq", :to => redirect("/faq")
  get "static/contact", :to => redirect("/contact")
  get "static/copyright", :to => redirect("/copyright")
  get "tools/compare_items", :to => redirect('/item_comparison')
  get "mining/ore_value", :to => redirect('/ore_value')

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
  #       get :short
  #       post :toggle
  #     end
  #
  #     collection do
  #       get :sold
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
  #       get :recent, :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end


  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
