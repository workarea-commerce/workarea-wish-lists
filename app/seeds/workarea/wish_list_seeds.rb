module Workarea
  class WishListSeeds
    def perform
      puts 'Adding wish lists...'

      5.times do
        user = Workarea::User.sample
        wish_list = Workarea::WishList.for_user(user.id)
        Workarea::Catalog::Product.limit(5).each do |product|
          sku = product.skus.sample
          quantity = rand(3) + 1

          next unless sku
          wish_list.add_item(product.id, sku, quantity)

          Metrics::ProductByDay.inc(
            key: { product_id: product.id },
            wish_list_adds: 1
          )

          if rand(2).zero?
            purchased_quantity = rand(quantity) + 1
            wish_list.mark_item_purchased(sku, purchased_quantity)

            Metrics::ProductByDay.inc(
              key: { product_id: product.id },
              wish_list_units_sold: purchased_quantity,
              wish_list_revenue: rand(10000) / 100.0
            )
          end
        end
      end
    end
  end
end
