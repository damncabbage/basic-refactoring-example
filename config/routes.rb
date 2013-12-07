ProductCatalogue::Application.routes.draw do
  resources :products do
    post 'import', on: :collection
  end
  root 'products#index'
end
