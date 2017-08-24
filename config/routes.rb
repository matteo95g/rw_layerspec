# frozen_string_literal: true
Rails.application.routes.draw do
  scope module: :v1, constraints: APIVersion.new(version: 1, current: true) do
    get    '/layer',          to: 'layers#index_all'
    resources :layers, path: 'layer'
    # post   '/layer',          to: 'layers#create'
    # get    '/layer/:id',      to: 'layers#show'
    # patch  '/layer/:id',      to: 'layers#update'
    # put    '/layer/:id',      to: 'layers#update'
    # delete '/layer/:id',      to: 'layers#destroy'
    get    'dataset/:dataset_id/layer',                 to: 'layers#index', constraints: DateableConstraint
    get    'dataset/:dataset_id/layer/:id',             to: 'layers#show'
    post   'dataset/:dataset_id/layer',                 to: 'layers#create'
    put    'dataset/:dataset_id/layer/:id',             to: 'layers#update'
    patch  'dataset/:dataset_id/layer/:id',             to: 'layers#update'
    delete 'dataset/:dataset_id/layer/:id',             to: 'layers#destroy'
    post   'layer/find-by-ids',                         to: 'layers#by_datasets'
    patch  'layer/change-environment/:dataset_id/:env', to: 'layers#change_env'

    get 'info', to: 'info#info'
    get 'ping', to: 'info#ping'
  end
end
