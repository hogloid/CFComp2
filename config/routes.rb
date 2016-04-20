Rails.application.routes.draw do
  get 'static_pages/home'  => 'static_pages#home'
  post 'static_pages/home' => 'static_pages#receive'
end
