Rails.application.routes.draw do
  scope module: :v1, constraints: APIVersion.new(version: 1, current: true) do
    resources :layers

    get '/info', to: 'layers#info'
    root         to: 'layers#docs'
  end
end
