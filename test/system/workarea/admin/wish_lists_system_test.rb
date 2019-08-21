require 'test_helper'

module Workarea
  module Admin
    class WishListsSystemTest < Workarea::SystemTest
      include Admin::IntegrationTest

      def test_wish_list_viewing
        user = create_user(email: 'bcrouse@workarea.com')
        wish_list = WishList.find_or_create_by!(user_id: user.id)

        products = Array.new(3) do |i|
          product = create_product(
            id: "PROD#{i}",
            name: "Test Product #{i}",
            variants: [{ sku: "SKU#{i}" }]
          )

          wish_list.add_item(product.id, product.variants.first.sku)
          product
        end

        visit admin.user_path(user)
        click_link t('workarea.admin.users.cards.wish_list.title')

        assert(page.has_content?(products.first.name))
        assert(page.has_content?(products.second.name))
        assert(page.has_content?(products.third.name))

        wish_list.items.first.update_attributes!(purchased: true)

        visit admin.user_wish_list_path(user)

        refute(page.has_content?(products.first.name))
        assert(page.has_content?(products.second.name))
        assert(page.has_content?(products.third.name))

        select t('workarea.storefront.wish_lists.purchased_items'), from: :state

        assert(page.has_content?(products.first.name))
        refute(page.has_content?(products.second.name))
        refute(page.has_content?(products.third.name))
      end
    end
  end
end
