require 'test_helper'

module Workarea
  class Catalog::Customizations::Foo < Catalog::Customizations
    customized_fields :foo, :baz
    validates_presence_of :foo
  end

  module Storefront
    class WishListsIntegrationTest < Workarea::IntegrationTest
      setup :user, :product

      def user
        @user ||= create_user(email: 'test@workarea.com', password: 'w3bl1nc')
      end

      def wish_list
        @wish_list ||= WishList.for_user(user.id)
      end

      def product
        @product ||= create_product(
          name: 'Integration Product',
          variants: [{ sku: 'SKU1', regular: 10.to_m }]
        )
      end

      def login
        post storefront.login_path,
             params: {
               email: 'test@workarea.com',
               password: 'w3bl1nc'
             }
      end

      def test_update
        login

        patch storefront.update_users_wish_list_path,
              params: { privacy: 'shared' }

        wish_list.reload
        assert(wish_list.shared?)

        patch storefront.update_users_wish_list_path,
              params: { privacy: 'private' }

        wish_list.reload
        assert(wish_list.private?)
      end

      def test_update_item_quantity
        login

        post storefront.add_to_users_wish_list_path,
             params: {
               product_id: product.id,
               sku:        product.skus.first,
               quantity:   1
             }

        assert_equal(1, wish_list.quantity)

        patch storefront.update_item_users_wish_list_path(wish_list.items.first),
              params: { quantity: 3 }

        wish_list.reload
        assert_equal(3, wish_list.quantity)
      end

      def test_add_item_with_customizations
        login

        product.update!(customizations: 'foo')

        assert_difference -> { wish_list.quantity } do
          post storefront.add_to_users_wish_list_path,
               params: {
                 product_id: product.id,
                 sku:        product.skus.first,
                 quantity:   1,
                 foo:        'bar',
                 baz:        'bat'
               }
          wish_list.reload
        end

        assert_redirected_to(storefront.users_wish_list_path)
        assert(wish_list.items.last.customizations.present?)
      end

      def test_add_item
        login

        post storefront.add_to_users_wish_list_path,
             params: {
               product_id: product.id,
               sku:        product.skus.first,
               quantity:   1
             }

        assert_equal(product.id, wish_list.items.first.product_id)
        assert_equal(product.skus.first, wish_list.items.first.sku)
        assert_equal(1, wish_list.items.first.quantity)
      end

      def test_add_item_after_login
        post storefront.add_to_users_wish_list_path,
             params: {
               product_id: product.id,
               sku:        product.skus.first,
               quantity:   1
             }

        login
        get storefront.users_wish_list_path

        assert_equal(1, wish_list.quantity)
        assert_equal(product.id, wish_list.items.first.product_id)
        assert_equal(product.skus.first, wish_list.items.first.sku)
        assert_equal(1, wish_list.items.first.quantity)
      end

      def test_remove_item
        login

        post storefront.add_to_users_wish_list_path,
             params: {
               product_id: product.id,
               sku:        product.skus.first,
               quantity:   1
             }

        delete storefront.remove_from_users_wish_list_path,
               params: { sku: product.skus.first }

        assert_equal(0, wish_list.quantity)
      end

      def test_cannot_add_out_of_stock_products_from_wish_list_to_cart
        inventory = create_inventory(
          id: 'SKU1',
          policy: 'standard',
          available: 1
        )

        login

        post storefront.add_to_users_wish_list_path,
          params: {
            product_id: product.id,
            sku:        product.skus.first,
            quantity:   1
          }

        inventory.update_attributes(available: 0)

        assert_equal(product.id, wish_list.items.first.product_id)
        assert_equal(product.skus.first, wish_list.items.first.sku)
        assert_equal(1, wish_list.items.first.quantity)

        get storefront.users_wish_list_path
        assert_select '.grid__cell' do
          assert_select('p[class="unavailable"]', true)
        end

        post storefront.cart_items_path,
          params: {
            product_id: wish_list.items.first.product_id,
            sku: wish_list.items.first.sku,
            quantity: 1
          }

        assert(response.ok?)

        order = Order.first
        order.reload
        assert_equal(0, order.quantity)
      end

      def test_back_out_of_moving_to_wish_list_as_guest
        post storefront.cart_items_path, params: {
          product_id: product.id,
          sku: product.skus.first,
          quantity: 1
        }
        order = Order.last
        item = order.items.first

        assert_response(:success)
        refute_empty(order.items)

        post storefront.from_cart_users_wish_list_path(item_id: item.id)

        assert_redirected_to(storefront.login_path)
        refute_empty(order.reload.items)
        assert(cookies[:wish_list_item_id].present?)

        login

        assert_redirected_to(storefront.users_wish_list_path)

        follow_redirect!

        assert_response(:success)
        assert(cookies[:wish_list_item_id].blank?)
        assert_empty(order.reload.items)
      end
    end
  end
end
