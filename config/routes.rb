Rails.application.routes.draw do
  get 'static_pages/home'  => 'static_pages#home'
  get 'static_pages/sandbox' => 'static_pages#sandbox'
  post 'static_pages/home' => 'static_pages#receive'
end
