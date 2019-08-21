require 'test_helper'

module Workarea
  module Storefront
    class WishListsSystemTest < Workarea::SystemTest
      include Storefront::SystemTest

      setup :user, :product

      def user
        @user ||= create_user(
          email: 'test@workarea.com',
          password: 'w3bl1nc',
          name: 'Ben Crouse'
        )
      end

      def product
        @product ||= create_product(
          name: 'Integration Product',
          variants: [
            { sku: 'SKU1', regular: 10.to_m, sale: 5.to_m, on_sale: true, details: { 'color' => ['Red'] } },
            { sku: 'SKU2', details: { 'color' => ['Blue'] } }
          ]
        )
      end

      def add_to_wish_list(product)
        visit storefront.product_path(product)
        select 'SKU1'
        click_link I18n.t('workarea.storefront.wish_lists.add_to_wish_list')
      end

      def login(email, password)
        visit storefront.login_path

        within '#login_form' do
          fill_in 'email', with: email
          fill_in 'password', with: password
          click_button 'login'
        end
      end

      def search_wish_lists(query)
        visit storefront.wish_lists_path

        within '#find_wish_list_form' do
          fill_in 'wish_list_query', with: query
          click_button 'search'
        end
      end

      def set_wishlist_privacy(privacy)
        wish_list = Workarea::WishList.first
        wish_list.privacy = privacy
        wish_list.save
      end

      def test_managing_items
        login('test@workarea.com', 'w3bl1nc')
        add_to_wish_list(product)

        visit storefront.users_wish_list_path
        assert(page.has_content?('Integration Product'))
        assert(page.has_content?('Red'))
        assert(page.has_content?('In Stock'))
        assert(page.has_content?('$10.00'))
        assert(page.has_content?('$5.00'))

        click_button 'remove_item'
        visit storefront.users_wish_list_path
        assert(page.has_no_content?('Integration Product'))
      end

      def test_toggle_between_purchased_and_unpurchased_items
        login('test@workarea.com', 'w3bl1nc')
        add_to_wish_list(product)

        visit storefront.users_wish_list_path
        assert(page.has_content?('Integration Product'))

        select I18n.t('workarea.storefront.wish_lists.purchased_items'), from: :state
        assert(page.has_no_content?('Integration Product'))

        select I18n.t('workarea.storefront.wish_lists.unpurchased_items'), from: :state
        assert(page.has_content?('Integration Product'))
      end

      def test_apply_variant_and_quantity_from_cart_form
        login('test@workarea.com', 'w3bl1nc')

        visit storefront.product_path(product)
        select 'SKU2'
        fill_in 'quantity', with: '3'
        click_link I18n.t('workarea.storefront.wish_lists.add_to_wish_list')

        assert(page.has_content?('SKU2'))
        assert(page.has_content?('Blue'))
        assert(page.has_selector?('input[name="quantity"][value="3"]'))
      end

      def test_cannot_add_if_cart_form_is_invalid
        login('test@workarea.com', 'w3bl1nc')

        visit storefront.product_path(product)
        click_link I18n.t('workarea.storefront.wish_lists.add_to_wish_list')
        assert(page.has_content?('This field is required'))
      end

      def test_add_item_to_wish_list_without_being_logged_in
        add_to_wish_list(product)
        login('test@workarea.com', 'w3bl1nc')

        visit storefront.users_account_path
        assert(page.has_content?('Integration Product'))
      end

      def test_updating_privacy
        login('test@workarea.com', 'w3bl1nc')
        visit storefront.users_wish_list_path

        choose 'privacy_shared'
        assert(page.has_content?(Workarea::WishList.first.token))
      end

      def test_finding_wish_list_by_name
        login('test@workarea.com', 'w3bl1nc')
        add_to_wish_list(product)
        search_wish_lists('Ben Crouse')

        refute_text(t('workarea.storefront.searches.no_results', terms: 'Ben Crouse'))

        within 'ol' do
          assert(page.has_content?('Ben Crouse'))
        end
      end

      def test_finding_wish_list_by_email
        login('test@workarea.com', 'w3bl1nc')
        add_to_wish_list(product)
        search_wish_lists('test@workarea.com')

        refute_text(t('workarea.storefront.searches.no_results', terms: 'test@workarea.com'))

        within 'ol' do
          assert(page.has_content?('Ben Crouse'))
        end
      end

      def test_viewing_a_wish_list
        login('test@workarea.com', 'w3bl1nc')
        add_to_wish_list(product)
        search_wish_lists('test@workarea.com')
        click_link 'Ben Crouse'

        assert(page.has_content?('Integration Product'))
        assert(page.has_content?('In Stock'))
      end

      def test_viewing_wish_list_summary_on_account_home
        login('test@workarea.com', 'w3bl1nc')

        product = create_product(
          name: 'Integration Product',
          variants: [{ sku: 'SKU1', regular: 10.to_m }]
        )

        visit storefront.product_path(product)
        click_link I18n.t('workarea.storefront.wish_lists.add_to_wish_list')

        visit storefront.users_account_path
        assert(page.has_content?('Integration Product'))
      end

      def test_adding_item_to_cart_from_wish_list
        login('test@workarea.com', 'w3bl1nc')

        product = create_product(
          name: 'Integration Product',
          variants: [{ sku: 'SKU1', regular: 10.to_m }]
        )

        visit storefront.product_path(product)
        click_link I18n.t('workarea.storefront.wish_lists.add_to_wish_list')

        visit storefront.users_wish_list_path
        click_button 'add_to_cart', match: :first

        assert(page.has_content?('Success'))
      end

      def test_moving_an_item_from_cart_to_wish_list
        login('test@workarea.com', 'w3bl1nc')

        product = create_product(
          name: 'Integration Product',
          variants: [{ sku: 'SKU1', regular: 10.to_m }]
        )

        visit storefront.product_path(product)
        click_button 'add_to_cart'
        wait_for_xhr

        visit storefront.cart_path
        click_button 'move_to_wish_list'

        visit storefront.users_wish_list_path
        assert(page.has_content?(product.name))
      end

      def test_moving_an_item_from_cart_to_wish_list_when_not_logged_in
        product = create_product(
          name: 'Integration Product',
          variants: [{ sku: 'SKU1', regular: 10.to_m }]
        )

        visit storefront.product_path(product)
        click_button 'add_to_cart'
        wait_for_xhr

        visit storefront.cart_path
        click_button 'move_to_wish_list'

        login('test@workarea.com', 'w3bl1nc')

        visit storefront.users_wish_list_path
        assert(page.has_content?(product.name))
      end

      def test_non_purchasable_products_cannot_be_added_to_wish_list
        product = create_product(purchasable: false)

        visit storefront.product_path(product)

        assert(page.has_no_content?('Add to Wish List'))
      end

      def test_private_wishlists_are_not_searchable
        set_wishlist_privacy('private')

        login('test@workarea.com', 'w3bl1nc')
        add_to_wish_list(product)
        search_wish_lists('test@workarea.com')
        assert(page.has_no_content?('Ben Crouse'))
      end

      def test_viewing_private_wish_list_summary_on_account_home
        login('test@workarea.com', 'w3bl1nc')
        set_wishlist_privacy('private')

        product = create_product(
          name: 'Integration Product',
          variants: [{ sku: 'SKU1', regular: 10.to_m }]
        )

        visit storefront.product_path(product)
        click_link I18n.t('workarea.storefront.wish_lists.add_to_wish_list')

        visit storefront.users_account_path
        assert(page.has_content?('Integration Product'))
      end

      def test_viewing_empty_wish_list
        login('test@workarea.com', 'w3bl1nc')

        visit storefront.users_wish_list_path

        assert_text(
          t(
            'workarea.storefront.wish_lists.empty.message',
            state: t('workarea.storefront.wish_lists.empty.states.unpurchased')
          )
        )

        select 'Purchased', from: 'state'
        wait_for_xhr

        assert_text(
          t(
            'workarea.storefront.wish_lists.empty.message',
            state: t('workarea.storefront.wish_lists.empty.states.purchased')
          )
        )
      end
    end
  end
end
