require 'test_helper'

module Workarea
  module Storefront
    class WishListUserViewModelTest < TestCase
      setup :user, :products

      def user
        @user ||= create_user(
          email: 'bcrouse@workarea.com',
          first_name: 'Ben',
          last_name: 'Crouse'
        )
      end

      def wish_list
        @wish_list ||= WishList.for_user(user.id)
      end

      def products
        @products ||=  [
          create_product(id: 'PROD1', variants: [{ sku: 'SKU1' }]),
          create_product(id: 'PROD2', variants: [{ sku: 'SKU2' }, { sku: 'SKU3' }])
        ]
      end

      def test_wish_list_items
        wish_list.add_item('PROD1', 'SKU1')
        wish_list.add_item('PROD2', 'SKU2')
        wish_list.add_item('PROD2', 'SKU3')
        wish_list.items.second.update_attributes!(purchased: true)

        view_model = UserViewModel.new(user)
        assert_equal(2, view_model.wish_list_items.size)
        assert_includes(view_model.wish_list_items.map(&:sku), 'SKU1')
        assert_includes(view_model.wish_list_items.map(&:sku), 'SKU3')

        products.first.update_attributes!(active: false)

        view_model = UserViewModel.new(user)
        assert_equal(1, view_model.wish_list_items.count)
        assert_equal('SKU3', view_model.wish_list_items.first.sku)
      end
    end
  end
end
