Workarea::Admin::Engine.routes.draw do
  scope '(:locale)', constraints: Workarea::I18n.routes_constraint do
    resources :users, only: [] do
      get :wish_list
    end
  end
end

Workarea::Storefront::Engine.routes.draw do
  scope '(:locale)', constraints: Workarea::I18n.routes_constraint do
    resources :wish_lists, only: [:index, :show]

    namespace :users do
      resource :wish_list, only: :show do
        post 'from_cart_item/:item_id', as: :from_cart, action: 'create_from_cart_item'
        post 'add_item', as: :add_to
        patch 'update_item_quantity/:item_id', as: :update_item, action: 'update_item_quantity'
        patch 'update', as: :update
        delete 'remove_item', as: :remove_from
      end
    end
  end
end
