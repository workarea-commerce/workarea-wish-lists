require 'test_helper'

module Workarea
  module Storefront
    class WishListItemViewModelTest < TestCase
      def test_product
        product = create_product
        item = create_wish_list.items.create(
          product_id: product.id,
          sku: 'VERYSKUMUCHPRODUCT'
        )

        view_model = WishListItemViewModel.wrap(item)
        assert_equal(ProductViewModel, view_model.product.class)
      end

      def test_purchasable?
        product = create_product(
          variants: [
            { sku: 'SKU1', regular: 5.to_m },
            { sku: 'SKU2', regular: 5.to_m }
          ]
        )

        Inventory::Sku
          .find_or_create_by(id: 'SKU1')
          .update_attributes(policy: 'standard', available: 5)

        Inventory::Sku
          .find_or_create_by(id: 'SKU2')
          .update_attributes(policy: 'standard', available: 0)

        wish_list = create_wish_list
        wish_list.add_item(product.id, 'SKU1')
        view_model = WishListItemViewModel.wrap(wish_list.items.first)

        assert(view_model.purchasable?)

        wish_list = create_wish_list
        wish_list.add_item(product.id, 'SKU2')
        view_model = WishListItemViewModel.wrap(wish_list.items.first)

        refute(view_model.purchasable?)
      end
    end
  end
end
