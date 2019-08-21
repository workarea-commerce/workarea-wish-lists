require 'test_helper'

module Workarea
  class MarkWishListItemsPurchasedTest < TestCase
    def test_perform
      user = create_user
      order = create_order(email: user.email, user_id: user.id)
      order.items.build(product_id: 'PROD1', sku: 'SKU1', quantity: 3)
      order.save!

      wish_list = WishList.for_user(user.id)
      wish_list.add_item('PROD1', 'SKU1', 3)

      MarkWishListItemsPurchased.new.perform(order.id)

      wish_list.reload
      assert_equal(3, wish_list.items.first.received)
      assert(wish_list.items.first.purchased?)
    end
  end
end
