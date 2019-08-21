module Workarea
  module WishList::Pricing
    # Build price adjustments and set order total prices.
    #
    # @param [Workarea::WishList] wish_list
    # @return [self]
    #
    def self.perform(wish_list)
      wish_list.reset_pricing!
      WishList::Request.new(wish_list).run
      self
    end
  end
end
