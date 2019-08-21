module Workarea
  class WishList::Pricing::Calculators::TotalsCalculator
    attr_reader :wish_list, :request

    def initialize(wish_list, request = nil)
      @wish_list = wish_list
      @request = request
    end

    def adjust
      set_item_totals
    end

    private

    def price_adjustments
      @price_adjustments ||= @wish_list.price_adjustments # Memoize for perf
    end

    def set_item_totals
      @wish_list.items.each do |item|
        item.total_price = item.price_adjustments.adjusting('item').sum
      end
    end
  end
end
