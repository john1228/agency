Rails.application.routes.draw do


  devise_for :admin_user
  devise_scope :admin_user do
    get 'logout', :to => 'devise/sessions#destroy'
  end


  mount Ckeditor::Engine => '/ckeditor'

  resources :services
  resources :coaches
  resources :dynamics
  resources :message
  resources :mass_message_groups
  resource :profile
  resources :admin_users
  resources :withdraws
  resources :transfers
  resources :orders
  resources :appointments
  resources :sales
  resources :membership_card_types
  resources :membership_cards do
    resources :membership_card_logs, path: 'records'
  end
  resources :members
  resources :skus
  resources :products

  get 'checkin' => 'checkin#index', as: :checkin
  get 'checkin/list' => 'checkin#list', as: :checkin_list


  get ':service_id/membership_card_types/:type/cards' => 'json#card_types'
  get ':service_id/coaches' => 'json#coaches'
  get ':service_id/salesman' => 'json#salesman'

  get 'transfers/:service_id/service' => 'transfers#service'


  get 'password' => 'profiles#password'
  post 'password' => 'profiles#change_password', as: :change_password

  get 'profile/photowall' => 'profiles#photowall'
  post 'profile/photowall' => 'profiles#update_photowall', as: :update_photowall
  get 'profile/showtime' => 'profiles#showtime'
  post 'profile/showtime' => 'profiles#update_showtime', as: :update_showtime

  get 'students' => 'students#index'
  get 'students/group' => 'students#group'
  post 'students/group' => 'students#create_group', as: :create_group
  delete 'students/group/:id' => 'students#delete_group'

  get 'groups/:id/students' => 'mass_message_groups#students'
  post 'groups/:id/students' => 'mass_message_groups#update'
  post 'groups' => 'mass_message_groups#create'

  get 'report' => 'report#course'

  post 'report/order' => 'report#order'
  post 'report/appointment' => 'report#appointment'
  post 'report/sale' => 'report#sale'

  get 'report/order' => 'report#order_table'
  get 'report/appointment' => 'report#appointment_table'
  get 'report/sale' => 'report#sale_table'
  get 'dashboard' => 'dashboard#index'

  post 'message' => 'message#create', as: :batch_message

  root to: 'dashboard#index'
end

