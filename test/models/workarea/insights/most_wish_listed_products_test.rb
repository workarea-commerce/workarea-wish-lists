require 'test_helper'

module Workarea
  module Insights
    class MostWishListedProductsTest < TestCase
      setup :add_data, :time_travel

      def add_data
        Metrics::ProductByDay.inc(
          key: { product_id: 'foo' },
          at: Time.zone.local(2018, 10, 27),
          wish_list_adds: 1
        )

        Metrics::ProductByDay.inc(
          key: { product_id: 'foo' },
          at: Time.zone.local(2018, 10, 28),
          wish_list_adds: 2
        )

        Metrics::ProductByDay.inc(
          key: { product_id: 'foo' },
          at: Time.zone.local(2018, 10, 29),
          wish_list_adds: 3
        )

        Metrics::ProductByDay.inc(
          key: { product_id: 'bar' },
          at: Time.zone.local(2018, 10, 27),
          wish_list_adds: 3
        )

        Metrics::ProductByDay.inc(
          key: { product_id: 'bar' },
          at: Time.zone.local(2018, 10, 28),
          wish_list_adds: 4
        )

        Metrics::ProductByDay.inc(
          key: { product_id: 'bar' },
          at: Time.zone.local(2018, 10, 29),
          wish_list_adds: 5
        )
      end

      def time_travel
        travel_to Time.zone.local(2018, 11, 1)
      end

      def test_generate_monthly!
        MostWishListedProducts.generate_monthly!
        assert_equal(1, MostWishListedProducts.count)

        wish_listed_products = MostWishListedProducts.first
        assert_equal(2, wish_listed_products.results.size)
        assert_equal('bar', wish_listed_products.results.first['product_id'])
        assert_in_delta(12, wish_listed_products.results.first['adds'])
        assert_equal('foo', wish_listed_products.results.second['product_id'])
        assert_in_delta(6, wish_listed_products.results.second['adds'])
      end
    end
  end
end
