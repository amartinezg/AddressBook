Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks]

  scope module: :v1, constraints: ApiVersion.new('v1', true) do
    resources :organizations
  end
end
