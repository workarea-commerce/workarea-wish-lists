module Workarea
  class MarkWishListItemsPurchased
    include Sidekiq::Worker
    include Sidekiq::CallbacksWorker

    sidekiq_options enqueue_on: { Order => :place }, queue: 'high'

    def perform(order_id)
      order = Order.find(order_id)
      return if order.user_id.blank?

      wish_list = Workarea::WishList.for_user(order.user_id)
      order.items.each do |item|
        wish_list.mark_item_purchased(item.sku, item.quantity)
      end
    end
  end
end
