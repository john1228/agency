Rails.application.routes.draw do

  devise_for :admin_user
  #devise_scope

  mount Ckeditor::Engine => '/ckeditor'

  resources :coaches
  resources :dynamics
  resources :message
  resources :mass_message_groups

  get 'profile' => 'profile#show'
  get 'profile/edit' => 'profile#edit'
  post 'profile' => 'profile#update', as: :update_profile

  get 'password' => 'profile#password'
  post 'password' => 'profile#change_password', as: :change_password

  get 'students' => 'students#index'
  get 'students/group' => 'students#group'
  post 'students/group' => 'students#create_group', as: :create_group

  get 'groups/:id/students' => 'mass_message_groups#students'
  post 'groups/:id/students' => 'mass_message_groups#update'
  post 'groups' => 'mass_message_groups#create'

  get 'report' => 'report#course'
  get 'report/coach' => 'report#coach'

  post 'report/order' => 'report#order'
  post 'report/appointment' => 'report#appointment'
  post 'report/sale' => 'report#sale'

  get 'finance/transfer' => 'finance#transfer_new'
  post 'finance/transfer' => 'finance#transfer_create', as: :submit_transfer
  post 'finance/batch_transfer' => 'finance#batch_transfer', as: :batch_transfer
  get 'finance/withdraw' => 'finance#withdraw_new'
  post 'finance/withdraw' => 'finance#withdraw_create', as: :submit_withdraw


  get 'dashboard' => 'dashboard#index'


  root to: 'dashboard#index'
end

