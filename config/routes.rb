# frozen_string_literal: true
Rails.application.routes.draw do
  scope module: :v1, constraints: APIVersion.new(version: 1, current: true) do
    resources :layers, path: 'layer'

    get  'dataset/:dataset_id/layer', to: 'layers#index', constraints: DateableConstraint
    post 'layer/find-by-ids',         to: 'layers#by_datasets'

    get 'info', to: 'info#info'
    get 'ping', to: 'info#ping'
  end
end
