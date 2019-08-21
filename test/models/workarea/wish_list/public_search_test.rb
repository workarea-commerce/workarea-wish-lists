require 'test_helper'

module Workarea
  class WishList
    class PublicSearchTest < TestCase
      setup :wish_list, :nameless_wish_list

      def email
        'test@workarea.com'
      end

      def first
        'Ben'
      end

      def last
        'Crouse'
      end

      def full_name
        [first, last].join(' ')
      end

      def other_email
        'test-again@workarea.com'
      end

      def another_email
        'test-other@workarea.com'
      end

      def wish_list
        @wish_list ||= create_wish_list(
          email:      email,
          name:       full_name,
          first_name: first,
          last_name:  last,
          location:   'Philadelphia PA 19106'
        )
      end

      def nameless_wish_list
        @nameless_wish_list ||= create_wish_list(
          email:      another_email,
          name: another_email,
          first_name: '',
          last_name: '',
          location:   'Philadelphia PA 19106'
        )
      end

      def test_results
        search = Workarea::WishList::PublicSearch.new(full_name)
        assert_equal([wish_list], search.results.to_a)

        search = Workarea::WishList::PublicSearch.new(another_email)
        refute_empty(search.results)

        search = Workarea::WishList::PublicSearch.new('bogus@example.com')
        assert_empty(search.results)

        search = Workarea::WishList::PublicSearch.new(email)
        assert_equal([wish_list], search.results.to_a)

        search = Workarea::WishList::PublicSearch.new(email)
        assert_equal([wish_list], search.results.to_a)

        search = Workarea::WishList::PublicSearch.new(full_name, 'Philadelphia')
        assert_equal([wish_list], search.results.to_a)

        search = Workarea::WishList::PublicSearch.new('bogus')
        assert(search.results.to_a.empty?)

        wish_list.update_attributes(privacy: 'private')
        assert(Workarea::WishList::PublicSearch.new(full_name).results.empty?)

        wish_list.update_attributes(privacy: 'shared')
        assert(Workarea::WishList::PublicSearch.new(full_name).results.empty?)
      end
    end
  end
end
