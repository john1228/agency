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
  resources :sales
  resources :membership_card_types
  resources :membership_cards do
    resources :membership_card_logs, path: 'records'
  end
  resources :members
  resources :skus
  resources :products

  
  namespace :api do
    post 'terminal' => 'terminal#active'
    get 'terminal' => 'terminal#show'
    post 'terminal/checkin' => 'terminal#checkin'
  end

  get 'checkin' => 'checkin#index', as: :checkin
  get 'checkin/pending' => 'checkin#pending', as: :pending_list
  get 'checkin/confirm' => 'checkin#confirm', as: :confirm_list
  get 'checkin/:id/card_list' => 'checkin#membership_card_list', as: :card_list
  patch 'checkin/:id' => 'checkin#update', as: :confirm_checkin
  post 'checkin/:id/ignore' => 'checkin#ignore', as: :ignore_checkin
  post 'checkin/:id/cancel' => 'checkin#cancel', as: :cancel_checkin

  post 'membership_cards/:id/active' => 'membership_cards#active', as: :active_membership_card
  post 'membership_cards/:id/disable' => 'membership_cards#disable', as: :disable_membership_card
  patch 'membership_cards/:id/transfer' => 'membership_cards#transfer', as: :transfer_membership_card
  get 'membership_cards/:id/transfer_list' => 'membership_cards#transfer_member', as: :transfer_members
  get 'membership_cards/:id/binding' => 'membership_cards#binding_request', as: :binding_request
  patch 'membership_cards/:id/binding' => 'membership_cards#binding_confirm', as: :binding_confirm
  get 'membership_cards/:id/charge' => 'membership_cards#charge_request', as: :charge_request
  patch 'membership_cards/:id/charge' => 'membership_cards#charge_confirm', as: :charge_confirm


  get ':service_id/membership_card_types/:type/cards' => 'json#card_types'
  get ':service_id/coaches' => 'json#coaches'
  get ':service_id/salesman' => 'json#salesman'
  get ':service_id/balance' => 'json#balance'
  get ':service_id/members' => 'json#member'

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
  post 'report/sale' => 'report#sale'

  get 'report/order' => 'report#order_table'
  get 'report/sale' => 'report#sale_table'
  get 'dashboard' => 'dashboard#index'

  post 'message' => 'message#create', as: :batch_message

  root to: 'dashboard#index'
end

