require 'test_helper'

module Workarea
  class WishListSessionTest < TestCase
    def session
      @seassion ||= {}
    end

    def wish_list_session
      @wish_list_session ||= WishListSession.new(session)
    end

    def test_store_item
      item_id = BSON::ObjectId.new.to_s
      params = {
        'product_id' => '1',
        'sku' => '2',
        'quantity' => 1,
        'item_id' => item_id
      }
      wish_list_session.store_item(params)
      assert_equal(
        {
          'wish_list_item_id' => item_id,
          'wish_list_product_id' => '1',
          'wish_list_sku' => '2',
          'wish_list_quantity' => 1
        },
        session
      )
    end

    def test_add_item
      wish_list = create_wish_list
      product = create_product(variants: [{ sku: 'SKU' }], details: { color: 'Red' })

      session['wish_list_product_id'] = product.id
      session['wish_list_sku'] = product.variants[0].sku
      session['wish_list_quantity'] = 1

      wish_list_session.add_item(wish_list)
      assert_equal(1, wish_list.items.count)
      assert({ 'color' => ['Red'] }, wish_list.items[0].product_attributes)
      assert(session.blank?)
    end
  end
end
