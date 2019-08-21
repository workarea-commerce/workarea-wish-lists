module Workarea
  class WishList::PublicSearch
    attr_reader :query, :location

    def initialize(query, location = '')
      @query    = query
      @location = location
    end

    def results
      regex = /^#{Regexp.quote(query)}/i
      criteria = [
        { name: regex },
        { first_name: regex },
        { last_name: regex },
        { email: query } # we don't want partial matching on email
      ]

      if location.present?
        loc_regex = /.*#{Regexp.quote(location)}.*/i
        Workarea::WishList.where(
          privacy: 'public',
          location: loc_regex,
          '$or' => criteria
        )
      else
        Workarea::WishList.where(
          privacy: 'public',
          '$or' => criteria
        )
      end.named
    end
  end
end
