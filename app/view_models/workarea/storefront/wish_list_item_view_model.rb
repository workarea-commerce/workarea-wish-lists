module Workarea
  module Storefront
    class WishListItemViewModel < ApplicationViewModel
      delegate :has_prices?, :primary_image, :name, :purchasable?, to: :product

      def product
        @product ||= ProductViewModel.wrap(
          product_model,
          sku: sku,
          pricing: options[:pricing],
          inventory: options[:inventory_collection]
        )
      end

      def customized?
        customizations.present?
      end

      def inventory_status
        InventoryStatusViewModel.new(inventory).message
      end

      private

      def inventory
        @inventory ||= options[:inventory] ||
                       Inventory::Sku.find_or_create_by(id: sku)
      end

      def product_model
        options[:product] || Catalog::Product.find(product_id)
      end
    end
  end
end
