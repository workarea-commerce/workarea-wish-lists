require 'workarea/testing/factories'

module Workarea
  module Factories
    module WishLists
      def create_wish_list(overrides = {})
        attributes = {
          user_id: BSON::ObjectId.new,
          email: 'bcrouse@workarea.com',
          first_name: 'Ben',
          last_name: 'Crouse',
          name: 'Ben Crouse',
          location: 'Philadelphia PA 19106'
        }.merge(overrides)

        WishList.create!(attributes)
      end
    end
  end
end

Workarea::Factories.add(Workarea::Factories::WishLists)
