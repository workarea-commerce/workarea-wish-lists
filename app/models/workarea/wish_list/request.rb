module Workarea
  module Pricing
    class WishList::Request
      delegate :items, to: :order

      def initialize(wish_list)
        @wish_list = wish_list
      end

      def pricing
        @pricing ||= Pricing::Collection.new(all_skus)
      end

      def order
        @wish_list
      end

      def run
        Workarea.config.wish_list_pricing_calculators.each do |klass|
          klass.constantize.new(self).adjust
        end
      end

      private

      def all_skus
        skus = [
          @wish_list.items.map(&:sku),
          @wish_list.items.map { |i| i.customizations['pricing_sku'] }
        ]

        skus.flatten.reject(&:blank?).uniq
      end
    end
  end
end
