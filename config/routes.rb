ActionController::Routing::Routes.draw do |map|
	# For debugging, check validations
	map.connect 'validate', :controller => 'application', :action => 'test_validations'

	# Bulk operations
	map.connect 'students/search', :controller => 'students', :action => 'search'
	map.connect 'students/bulkoperations', :controller => 'students', :action => 'bulk_operations'
	map.connect 'graduations/new_bulk', :controller => 'graduations', :action => 'new_bulk'
	map.connect 'graduations/update_bulk', :controller => 'graduations', :action => 'update_bulk'
	map.connect 'payments/new_bulk', :controller => 'payments', :action => 'new_bulk'
	map.connect 'payments/update_bulk', :controller => 'payments', :action => 'update_bulk'

	# Clubs, students and subresources
	map.resources :clubs, :shallow => true do |club|
		club.resources :students do |student|
			student.resources :payments
			student.resources :graduations
		end
	end

	# Other singular resources
	map.resources :users
	map.resources :groups
	map.resources :mailing_lists

	# For login and logout
	map.resource :user_session

	# Display club list at /
	map.root :controller => :clubs

	# map.root :controller => "user_sessions", :action => "new"

	# The priority is based upon order of creation: first created -> highest priority.

	# Sample of regular route:
	#   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
	# Keep in mind you can assign values other than :controller and :action

	# Sample of named route:
	#   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
	# This route can be invoked with purchase_url(:id => product.id)

	# Sample resource route (maps HTTP verbs to controller actions automatically):
	#   map.resources :products

	# Sample resource route with options:
	#   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

	# Sample resource route with sub-resources:
	#   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

	# Sample resource route with more complex sub-resources
	#   map.resources :products do |products|
	#     products.resources :comments
	#     products.resources :sales, :collection => { :recent => :get }
	#   end

	# Sample resource route within a namespace:
	#   map.namespace :admin do |admin|
	#     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
	#     admin.resources :products
	#   end

	# You can have the root of your site routed with map.root -- just remember to delete public/index.html.
	# map.root :controller => "welcome"

	# See how all your routes lay out with "rake routes"

	# Install the default routes as the lowest priority.
	# Note: These default routes make all actions in every controller accessible via GET requests. You should
	# consider removing the them or commenting them out if you're using named routes and resources.
	# map.connect ':controller/:action/:id'
	# map.connect ':controller/:action/:id.:format'
end
