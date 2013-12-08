ProductCatalogue::Application.routes.draw do
  resources :products, only: [:index, :new, :create, :destroy] do
    post 'import', on: :collection
  end
  root 'products#index'
end
