require 'test_helper'

module Workarea
  class WishListTest < TestCase
    def user
      @user ||= create_user(
        first_name: 'Foo',
        last_name: 'Bar',
        email: 'test@workarea.com',
        addresses: [{
          first_name: 'Ben',
          last_name: 'Crouse',
          street: '22 S. 3rd St.',
          street_2: 'Second Floor',
          city: 'Philadelphia',
          region: 'PA',
          postal_code: '19106',
          country: 'US'
        }]
      )
    end

    def wish_list
      @wish_list ||= WishList.new(user_id: user.id)
    end

    def order
      @order ||= Workarea::Order.new(email: 'test@workarea.com')
    end

    def test_creation
      WishList.destroy_all

      wish_list = WishList.for_user(user.id)

      assert_equal('Foo', wish_list.first_name)
      assert_equal('Bar', wish_list.last_name)
      assert_equal('Foo Bar', wish_list.name)
      assert_equal('Philadelphia PA US 19106', wish_list.location)
      assert_equal('test@workarea.com', wish_list.email)

      existing_wish_list = WishList.for_user(user.id)
      assert_equal(wish_list, existing_wish_list)
    end

    def test_find_by_token
      token = 'kjh23r98b'
      wish_list.update_attributes(token: token)
      assert_equal(wish_list, WishList.find_by_token(token))

      assert_raise(Workarea::WishList::InvalidToken) { WishList.find_by_token(nil) }

      wish_list.update_attributes(token: 'kjh23r98b')
      assert_raise(Workarea::WishList::InvalidToken) { WishList.find_by_token('sdkg12gaweb') }

      token = 'kjh23r98b'
      wish_list.update_attributes(token: token, privacy: 'private')
      assert_raise(Workarea::WishList::InvalidToken) { WishList.find_by_token(token) }
    end

    def test_find_products
      wish_list.add_item('1234', 'SKU1', 1)
      assert_equal(['1234'], Workarea::WishList.find_products(user.id))
    end

    def test_named
      create_wish_list(name: '')
      create_wish_list(name: 'Zac Owen')

      assert_equal(1, Workarea::WishList.named.size)
      create_wish_list(name: 'Foo Bar', email: 'test@test.com')
      assert_equal(2, Workarea::WishList.named.size)
    end

    def test_public
      wish_list.update_attributes(privacy: 'public')

      assert(wish_list.public?)
      refute(wish_list.shared?)
      refute(wish_list.private?)
    end

    def test_shared
      wish_list.update_attributes(privacy: 'shared')

      refute(wish_list.public?)
      assert(wish_list.shared?)
      refute(wish_list.private?)
    end

    def test_private
      wish_list.update_attributes(privacy: 'private')

      refute(wish_list.public?)
      refute(wish_list.shared?)
      assert(wish_list.private?)
    end

    def test_add_item
      product_id = '1234'
      sku = 'SKU'

      wish_list.add_item(product_id, sku, 2)
      assert_equal(2, wish_list.quantity)
      assert_equal(product_id, wish_list.items.last.product_id)
      assert_equal(sku, wish_list.items.last.sku)
      assert_equal(2, wish_list.items.last.quantity)

      wish_list.add_item(product_id, sku, 2)
      assert_equal(1, wish_list.items.length)
      assert_equal(4, wish_list.items.last.quantity)
    end

    def test_add_item_with_customizations
      product = create_product(customizations: 'unit')
      sku = 'SKU'

      assert(wish_list.add_item(product.id, sku, 2, {}, foo: 'bar'))
      assert_equal(2, wish_list.quantity)
      assert_equal(product.id, wish_list.items.last.product_id)
      assert_equal(sku, wish_list.items.last.sku)
      assert_equal(2, wish_list.items.last.quantity)
      assert(wish_list.items.last.customizations.present?)
      assert_equal('bar', wish_list.items.last.customizations[:foo])

      wish_list.add_item(product.id, sku, 2, {}, foo: 'bar')
      assert_equal(1, wish_list.items.length)
      assert_equal(4, wish_list.items.last.quantity)
      assert(wish_list.items.last.customizations.present?)
      assert_equal('bar', wish_list.items.last.customizations[:foo])

      wish_list.add_item(product.id, sku, 2, {}, foo: 'baz')
      assert_equal(2, wish_list.items.length)
      assert(wish_list.items.last.customizations.present?)
      assert_equal('baz', wish_list.items.last.customizations[:foo])
    end

    def test_mark_item_purchased
      order.items.build(product_id: '1234', sku: 'SKU', quantity: 1)

      item = wish_list.items.build(product_id: '1234', sku: 'SKU', quantity: 1)

      wish_list.mark_item_purchased(item.sku, item.quantity)
      assert(wish_list.unpurchased_items.empty?)
      assert_includes(wish_list.purchased_items, item)
      assert_equal(1, wish_list.items.first.received)
    end

    def test_remove_item
      sku = 'SKU'
      item = wish_list.items.build(product_id: '1234', sku: sku, quantity: 2)

      assert_equal(2, wish_list.quantity)
      wish_list.remove_item(sku)
      assert_equal(0, wish_list.quantity)
    end
  end
end
