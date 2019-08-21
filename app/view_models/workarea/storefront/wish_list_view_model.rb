module Workarea
  module Storefront
    class WishListViewModel < ApplicationViewModel
      def name
        user.name.present? ? user.name : user.email
      end

      def items
        @items ||=
          begin
            items = if options[:state] == 'purchased'
              model.purchased_items
            else
              model.unpurchased_items
            end

            items.map do |item|
              product = products.detect { |p| p.id == item.product_id }

              next unless product.active?

              item = Storefront::OrderItemViewModel.new(item)

              WishListItemViewModel.new(
                item,
                product: product,
                inventory: inventory.for_sku(item.sku),
                inventory_collection: inventory,
                pricing: pricing
              )
            end.compact
          end
      end

      def state_options
        [
          [I18n.t('workarea.storefront.wish_lists.unpurchased_items'), :unpurchased],
          [I18n.t('workarea.storefront.wish_lists.purchased_items'), :purchased]
        ]
      end

      def empty_state
        I18n.t(
          options[:state] || :unpurchased,
          scope: 'workarea.storefront.wish_lists.empty.states'
        )
      end

      def empty_text
        I18n.t(
          'workarea.storefront.wish_lists.empty.message',
          state: empty_state
        )
      end

      private

      def user
        @user ||= User.find(user_id)
      end

      def products
        @products ||= Catalog::Product.find(model.items.map(&:product_id))
      end

      def inventory
        @inventory ||= Inventory::Collection.new(model.items.map(&:sku))
      end

      def pricing
        @pricing ||= Pricing::Collection.new(model.items.map(&:sku))
      end
    end
  end
end
