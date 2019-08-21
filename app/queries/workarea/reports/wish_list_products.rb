module Workarea
  module Reports
    class WishListProducts
      include Report

      self.reporting_class = Metrics::ProductByDay
      self.sort_fields = %w(revenue units_sold adds deletes)

      def aggregation
        [filter_results, project_used_fields, group_by_product]
      end

      def filter_results
        {
          '$match' => {
            'reporting_on' => { '$gte' => starts_at, '$lte' => ends_at },
            '$or' => [
              { 'wish_list_adds' => { '$gt' => 0 } },
              { 'wish_list_deletes' => { '$gt' => 0 } },
              { 'wish_list_units_sold' => { '$gt' => 0 } }
            ]
          }
        }
      end

      def project_used_fields
        {
          '$project' => {
            'product_id' => 1,
            'wish_list_units_sold' => 1,
            'wish_list_adds' => 1,
            'wish_list_deletes' => 1,
            'wish_list_revenue' => 1
          }
        }
      end

      def group_by_product
        {
          '$group' => {
            '_id' => '$product_id',
            'units_sold' => { '$sum' => '$wish_list_units_sold' },
            'adds' => { '$sum' => '$wish_list_adds' },
            'deletes' => { '$sum' => '$wish_list_deletes' },
            'revenue' => { '$sum' => '$wish_list_revenue' }
          }
        }
      end
    end
  end
end
