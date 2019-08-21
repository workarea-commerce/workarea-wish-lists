require 'test_helper'

module Workarea
  module Reports
    class WishListProductsTest < TestCase
      setup :add_data, :time_travel

      def add_data
        Metrics::ProductByDay.inc(
          key: { product_id: 'foo' },
          at: Time.zone.local(2018, 10, 27),
          wish_list_units_sold: 2,
          wish_list_revenue: 10.to_m,
          wish_list_adds: 2,
          wish_list_deletes: 1
        )

        Metrics::ProductByDay.inc(
          key: { product_id: 'foo' },
          at: Time.zone.local(2018, 10, 28),
          wish_list_units_sold: 4,
          wish_list_revenue: 15.to_m,
          wish_list_adds: 1,
          wish_list_deletes: 0
        )

        Metrics::ProductByDay.inc(
          key: { product_id: 'foo' },
          at: Time.zone.local(2018, 10, 29),
          wish_list_units_sold: 6,
          wish_list_revenue: 27.to_m,
          wish_list_adds: 1,
          wish_list_deletes: 1
        )

        Metrics::ProductByDay.inc(
          key: { product_id: 'bar' },
          at: Time.zone.local(2018, 10, 27),
          wish_list_units_sold: 3,
          wish_list_revenue: 11.to_m,
          wish_list_adds: 2,
          wish_list_deletes: 2
        )

        Metrics::ProductByDay.inc(
          key: { product_id: 'bar' },
          at: Time.zone.local(2018, 10, 28),
          wish_list_units_sold: 5,
          wish_list_revenue: 15.to_m,
          wish_list_adds: 1,
          wish_list_deletes: 1
        )

        Metrics::ProductByDay.inc(
          key: { product_id: 'bar' },
          at: Time.zone.local(2018, 10, 29),
          wish_list_units_sold: 7,
          wish_list_revenue: 27.to_m,
          wish_list_adds: 0,
          wish_list_deletes: 1
        )
      end

      def time_travel
        travel_to Time.zone.local(2018, 10, 30)
      end

      def test_grouping_and_summing
        report = WishListProducts.new
        assert_equal(2, report.results.length)

        foo = report.results.detect { |r| r['_id'] == 'foo' }
        assert_equal(12, foo['units_sold'])
        assert_equal(52, foo['revenue'])
        assert_equal(4, foo['adds'])
        assert_equal(2, foo['deletes'])

        bar = report.results.detect { |r| r['_id'] == 'bar' }
        assert_equal(15, bar['units_sold'])
        assert_equal(53, bar['revenue'])
        assert_equal(3, bar['adds'])
        assert_equal(4, bar['deletes'])
      end

      def test_date_ranges
        report = WishListProducts.new
        foo = report.results.detect { |r| r['_id'] == 'foo' }
        assert_equal(4, foo['adds'])

        report = WishListProducts.new(starts_at: '2018-10-28', ends_at: '2018-10-28')
        foo = report.results.detect { |r| r['_id'] == 'foo' }
        assert_equal(1, foo['adds'])

        report = WishListProducts.new(starts_at: '2018-10-28', ends_at: '2018-10-29')
        foo = report.results.detect { |r| r['_id'] == 'foo' }
        assert_equal(2, foo['adds'])

        report = WishListProducts.new(starts_at: '2018-10-28')
        foo = report.results.detect { |r| r['_id'] == 'foo' }
        assert_equal(2, foo['adds'])

        report = WishListProducts.new(ends_at: '2018-10-28')
        foo = report.results.detect { |r| r['_id'] == 'foo' }
        assert_equal(3, foo['adds'])
      end

      def test_sorting
        report = WishListProducts.new(sort_by: 'adds', sort_direction: 'asc')
        assert_equal('bar', report.results.first['_id'])

        report = WishListProducts.new(sort_by: 'adds', sort_direction: 'desc')
        assert_equal('foo', report.results.first['_id'])

        report = WishListProducts.new(sort_by: 'units_sold', sort_direction: 'asc')
        assert_equal('foo', report.results.first['_id'])

        report = WishListProducts.new(sort_by: 'units_sold', sort_direction: 'desc')
        assert_equal('bar', report.results.first['_id'])
      end
    end
  end
end
