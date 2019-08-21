require 'test_helper'

module Workarea
  module Storefront
    class WishListViewModelTest < TestCase
      def test_name
        user = create_user(email: 'test@workarea.com', first_name: 'Ben', last_name: 'Crouse')
        wish_list = create_wish_list(user_id: user.id)

        view_model = WishListViewModel.new(wish_list)
        assert_equal('Ben Crouse', view_model.name)

        wish_list.destroy!
        user.update_attributes!(first_name: nil, last_name: nil)
        wish_list = WishList.for_user(user.id)
        view_model = WishListViewModel.new(wish_list)

        assert_equal('test@workarea.com', view_model.name)
      end

      def test_items
        products = [
          create_product(id: '1', variants: [{ sku: 'sku1' }]),
          create_product(id: '2', variants: [{ sku: 'sku2' }, { sku: 'sku3' }])
        ]

        wish_list = create_wish_list
        wish_list.add_item('1', 'sku1')
        wish_list.add_item('2', 'sku2')
        wish_list.add_item('2', 'sku3')

        view_model = WishListViewModel.new(wish_list)
        assert_equal(3, view_model.items.count)

        wish_list.items.second.update_attributes!(purchased: true)
        view_model = WishListViewModel.new(wish_list, state: 'purchased')
        assert_equal(1, view_model.items.count)

        products.first.update_attributes!(active: false)
        view_model = WishListViewModel.new(wish_list)
        assert_equal(1, view_model.items.count)
      end

      def test_state_options
        values = WishListViewModel.new(create_wish_list).state_options.map(&:last)
        assert_equal(%i(unpurchased purchased), values)
      end

      def test_empty_state
        wish_list = WishListViewModel.new(create_wish_list)

        assert_equal(t('workarea.storefront.wish_lists.empty.states.unpurchased'), wish_list.empty_state)
        wish_list.stubs(:empty_state).returns('purchased')
        assert_equal(t('workarea.storefront.wish_lists.empty.states.purchased'), wish_list.empty_state)
      end

      def test_empty_text
        wish_list = WishListViewModel.new(create_wish_list)
        unpurchased = t(
          'workarea.storefront.wish_lists.empty.message',
          state: t('workarea.storefront.wish_lists.empty.states.unpurchased')
        )
        purchased = t(
          'workarea.storefront.wish_lists.empty.message',
          state: t('workarea.storefront.wish_lists.empty.states.purchased')
        )

        assert_equal(unpurchased, wish_list.empty_text)
        wish_list.stubs(:empty_state).returns('purchased')
        assert_equal(purchased, wish_list.empty_text)
      end
    end
  end
end
