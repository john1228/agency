Rails.application.routes.draw do

  devise_for :admin_user
  #devise_scope

  mount Ckeditor::Engine => '/ckeditor'

  resources :coaches
  resources :dynamics
  resources :message
  resources :mass_message_groups
  resource :profile

  get 'password' => 'profiles#password'
  post 'password' => 'profiles#change_password', as: :change_password

  get 'profile/photowall' => 'profiles#photowall'
  post 'profile/photowall' => 'profiles#photowall'
  get 'profile/showtime' => 'profiles#photowall'
  post 'profile/showtime' => 'profiles#photowall'

  get 'students' => 'students#index'
  get 'students/group' => 'students#group'
  post 'students/group' => 'students#create_group', as: :create_group

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


  get 'finance/transfer' => 'finance#transfer_new'
  post 'finance/transfer' => 'finance#transfer_create', as: :submit_transfer
  post 'finance/batch_transfer' => 'finance#batch_transfer', as: :batch_transfer
  get 'finance/withdraw' => 'finance#withdraw_new'
  post 'finance/withdraw' => 'finance#withdraw_create', as: :submit_withdraw


  get 'dashboard' => 'dashboard#index'


  root to: 'dashboard#index'
end

