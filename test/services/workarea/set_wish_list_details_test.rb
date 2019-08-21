require 'test_helper'

module Workarea
  class SetWishListDetailsTest < TestCase
    def test_perform
      Sidekiq::Callbacks.disable(UpdateWishListDetails) do
        wish_list = create_wish_list(user_id: nil)
        SetWishListDetails.new(wish_list).perform # should raise no error

        wish_list = create_wish_list(user_id: 'not_an_id')
        SetWishListDetails.new(wish_list).perform # should raise no error

        user = create_user(
          first_name: nil,
          last_name: nil,
          email: 'test@workarea.com'
        )

        wish_list = WishList.for_user(user.id)
        SetWishListDetails.new(wish_list).perform

        assert_equal('test@workarea.com', wish_list.email)
        assert_equal(wish_list.email, wish_list.name)
        refute(wish_list.first_name.present?)
        refute(wish_list.last_name.present?)
        refute(wish_list.location.present?)

        user.update_attributes!(
          first_name: 'Foo',
          last_name: 'Bar'
        )
        SetWishListDetails.new(wish_list).perform

        assert_equal('test@workarea.com', wish_list.email)
        assert_equal('Foo Bar', wish_list.name)
        assert_equal('Foo', wish_list.first_name)
        assert_equal('Bar', wish_list.last_name)
        refute(wish_list.location.present?)

        user.update_attributes!(
          addresses: [{
            first_name: 'Ben',
            last_name: 'Crouse',
            street: '22 S. 3rd St.',
            street_2: 'Second Floor',
            city: 'Philadelphia',
            region: 'PA',
            postal_code: '19106',
            country: 'US'
          }]
        )
        SetWishListDetails.new(wish_list).perform

        assert_equal('test@workarea.com', wish_list.email)
        assert_equal('Foo Bar', wish_list.name)
        assert_equal('Foo', wish_list.first_name)
        assert_equal('Bar', wish_list.last_name)
        assert_equal('Philadelphia PA US 19106', wish_list.location)
      end
    end
  end
end
