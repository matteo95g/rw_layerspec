# frozen_string_literal: true
Rails.application.routes.draw do
  scope module: :v1, constraints: APIVersion.new(version: 1, current: true) do
    resources :layers, path: 'layer'

    get    'dataset/:dataset_id/layer',     to: 'layers#index', constraints: DateableConstraint
    get    'dataset/:dataset_id/layer/:id', to: 'layers#show'
    post   'dataset/:dataset_id/layer',     to: 'layers#create'
    put    'dataset/:dataset_id/layer/:id', to: 'layers#update'
    patch  'dataset/:dataset_id/layer/:id', to: 'layers#update'
    delete 'dataset/:dataset_id/layer/:id', to: 'layers#destroy'
    post   'layer/find-by-ids',             to: 'layers#by_datasets'

    get 'info', to: 'info#info'
    get 'ping', to: 'info#ping'
  end
end
