module Workarea
  class WishList::Item
    include Mongoid::Document
    include Mongoid::Timestamps

    field :product_id, type: String
    field :quantity, type: Integer, default: 1
    field :received, type: Integer, default: 0
    field :sku, type: String
    field :product_details, type: Hash, default: {}
    field :sku_details, type: Hash, default: {}
    field :customizations, type: Hash, default: {}
    field :purchased, type: Boolean, default: false
    field :discountable, type: Boolean, default: true
    field :contributes_to_shipping, type: Boolean, default: true
    field :product_attributes, type: Hash, default: {}
    field :total_price, type: Money, default: 0

    embedded_in :wish_list, inverse_of: :items

    embeds_many :price_adjustments,
                class_name: 'Workarea::PriceAdjustment',
                extend: Workarea::PriceAdjustmentExtension

    validates :product_id, presence: true
    validates :sku, presence: true
    validates :quantity, presence: true,
                         numericality: {
                           greater_than_or_equal_to: 1,
                           only_integer: true
                         }

    def details=(details)
      write_attributes(
        details.slice(
          :product_details,
          :sku_details,
          :product_attributes
        )
      )

      self
    end

    # Adds a price adjustment to the item. Does not persist.
    #
    # @return [self]
    #
    def adjust_pricing(options = {})
      price_adjustments.build(options)
    end

    # Clears out all pricing for this item.
    #
    def reset_pricing!
      price_adjustments.delete_all
    end

    # The base price per-unit for this item.
    #
    # @return [Money]
    #
    def unit_price
      price_adjustments.first.unit.to_m
    end

    # Whether this item is on sale (as of the last time the
    # order was priced).
    #
    # @return [Boolean]
    #
    def on_sale?
      !!price_adjustments.first.data['on_sale']
    end
  end
end
