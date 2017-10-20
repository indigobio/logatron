Rails.application.routes.draw do
  match '/my_route',  to: 'my#index', via: 'get'
end
