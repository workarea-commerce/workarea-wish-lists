module Workarea
  module Storefront
    module WishListAnalyticsHelper
      def add_to_wish_list_analytics_data(product)
        {
          event: 'addToWishList',
          domEvent: 'click',
          payload: product_analytics_data(product)
        }
      end

      def remove_from_wish_list_analytics_data(product)
        {
          event: 'removeFromWishList',
          domEvent: 'submit',
          payload: product_analytics_data(product)
        }
      end
    end
  end
end
