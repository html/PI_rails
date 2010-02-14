ActionController::Routing::Routes.draw do |map|

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
  map.connect '/menu', :controller => :common, :action => 'menu'
  map.connect '/update_page_info', :controller => 'common', :action => 'update_page_info'
  map.connect '/search', :action => 'search', :controller => 'ads'
  map.subdomain_connect ':controller.:host/sitemap.xml', :action => 'sitemap'
  map.subdomain_connect ':host/sitemap.xml', :controller => 'common', :action => 'sitemap'
  map.subdomain_connect ':controller.:host/new/:tag_list', :action => 'new'
  map.subdomain_connect ':controller.:host/create/:tag_list', :action => 'create'
  map.subdomain_connect ':controller.:host/by_tag/:tag', :action => 'by_tag'
  map.subdomain_connect ':controller.:host/delete/:id', :action => 'destroy'
  map.subdomain_connect ':controller.:host/:action/:id'
  map.root :controller => 'index'
  map.photos '/', :controller => 'photos', :action => 'index'
  map.article '/show/:id', :controller => 'articles', :action => 'show'
  map.articles '/', :controller => 'articles', :action => 'index'
  map.ad '/show/:id', :controller => 'ads', :action => 'show'
  map.ads '/', :controller => 'ads', :action => 'index'
  #Following routes do not work
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
