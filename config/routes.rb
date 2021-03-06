Rails.application.routes.draw do

  resources :consignees
  resources :departs
  resources :trucks
  get 'waybillorders/update_departs' => 'waybillorders#update_departs' ,:as=>'update_departs',:defaults => { :format => 'js' }
  get 'waybillorders/print/:id'=>'waybillorders#print' ,:as=>'print'
  resources :waybillorders
  resources :lines
  resources :users
  get 'page/index'
  get 'page/personalcenter'
  get 'login'=> 'page#login'
  get "regent" => "users#new", :as => "regent"
  get "managecenter"=>"page#managecenter",:as=>"managecenter"
  delete 'logout' =>'users#logout'
  root 'page#index'
  post "create_login_session" => "users#create_login_session"
  post "/lines/new" => "lines#create"
  resources :paymentmethods
  resources :consignors
  resources :companies
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
