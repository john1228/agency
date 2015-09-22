Rails.application.routes.draw do
  devise_for :admin_users
  mount Ckeditor::Engine => '/ckeditor'

  resources :coaches
  resources :dynamics
  resources :profile
  resources :message
  resources :students

  get 'report' => 'report#index'
  get 'report/order' => 'report#order'
  get 'report/appointment' => 'report#appointment'
  get 'report/coach' => 'report#coach'

  get 'password' => 'profile#password'
  post 'password' => 'profile#change_password', as: :change_password

  get 'finance/transfer' => 'finance#transfer_new'
  post 'finance/transfer' => 'finance#transfer_create', as: :submit_transfer
  get 'finance/withdraw' => 'finance#withdraw_new'
  post 'finance/withdraw' => 'finance#withdraw_create', as: :submit_withdraw

  get 'dashboard' => 'dashboard#index'
  root :to => 'dashboard#index'
end

