Workarea Wish Lists 3.0.1 (2019-04-16)
--------------------------------------------------------------------------------

*   Search Un-named Wish Lists by Email

    Since `Workarea::User#name` is now set to the email if a first/last name
    do not exist, update the wish list's name to always match that of the
    user. This allows searching wish lists by email when the user does not
    have a name associated with their account.

    WISHLISTS-124
    Tom Scott



Workarea Wish Lists 3.0.0 (2019-03-13)
--------------------------------------------------------------------------------

*   Point Gemfile to gem server

    Curt Howard

*   Assert Lack of "No Results" Text In Storefront System Tests

    Add specific assertions to ensure the correct results are appearing when
    users search for wish lists by email or full name. This ensures that the
    test will catch when wish list searches don't come up with any results.

    WISHLISTS-109
    Tom Scott

*   Update for workarea v3.4 compatibility

    WISHLISTS-123
    Matt Duffy

*   Improve Reliability of "Add to Wish List" Button

    To make this button a bit less error-prone when wish-lists is combined
    with other plugins, use JS to perform the "Add to Wish List" request
    rather than relying on copying data from the PDP `<form>` into the
    `<form>` for adding a product to the wish list.

    WISHLISTS-122
    Tom Scott



Workarea Wish Lists 2.1.3 (2019-02-05)
--------------------------------------------------------------------------------

*   Update for workarea v3.4 compatibility

    WISHLISTS-123
    Matt Duffy

*   Return Item to Cart After Backing Out Of Moving to Wish List

    When a guest user attempts to move their item from cart to a wish list,
    Workarea presents them with a login page. If the user does not choose to
    log in, they will lose the item that they had previously added to cart
    even though it's still stored in their session. If the cart page is
    accessed, and there's a wish list item still stored in the session, the
    wish list item will be "dumped" back into the cart instead of being
    moved to the wish list.

    WISHLISTS-104
    Tom Scott



Workarea Wish Lists 2.1.2 (2019-01-08)
--------------------------------------------------------------------------------

*   Update README

    WISHLISTS-120
    Matt Duffy



Workarea Wish Lists 2.1.1 (2018-08-21)
--------------------------------------------------------------------------------

*   Retain Customizations When Adding to Wish List

    When adding a product to a wish list, customizations for that product
    were not being retained and copied into the wish list (or added
    directly). Update the `storefront/users/wish_lists#add_item` action to
    copy in customizations from the order item, and not error out when
    adding a product to wish list, or moving a product from cart to wish
    list. Additionally, while testing this issue, it was discovered that
    customizations are not considered when searching for a wish list item
    that already exists (so its quantity can be updated). The
    `WishList#add_item` instance method will now factor in the passed-in
    customizations, and unless they differ, update the quantity for the
    existing item. If customizations do differ, the item is treated as
    unique and appears as an additional line item on orders/wish lists.

    WISHLISTS-84
    Tom Scott



Workarea Wish Lists 2.1.0 (2018-05-24)
--------------------------------------------------------------------------------

*   Delegate purchasability of wish list item to product, setup for minor

    As of workarea v3.3.0, Storefront::ProductViewModel#purchasable? also
    checks inventory. This makes the method for wish list items unnecessary
    and so the method is simply delegated to the product. Test was updated
    to reflect this behavior

    WISHLISTS-116
    Matt Duffy

*   Fix seeding test/dummy app

    Add **db/seeds.rb** file in order for the seed task to function.

    WISHLISTS-114
    Tom Scott

*   Leverage Workarea Changelog task

    ECOMMERCE-5355
    Curt Howard

*   Remove unnecessary unique_args

    Tom Scott

*   Fix rendering of unavailability messaging

    The unavailability messaging wouldn’t render because it wasn’t nested in a grid__cell
    * Add a integration test to make sure users cannot add out of stock products on their wish list to cart
    * Assert that the message is rendering within a grid__cell

    WISHLISTS-115
    Dave Barnow

*   Catch error when UpdateWishListDetails fails

    If `Workarea::UpdateWishListDetails` fails because of a mongo index
    snafu, we can rescue the job and try resetting its details at a later
    time.

    WISHLISTS-81
    Tom Scott

*   Use a more expected number of items in seeds

    Ben Crouse



Workarea Wish Lists 2.0.5 (2018-05-01)
--------------------------------------------------------------------------------

*   Catch error when UpdateWishListDetails fails

    If `Workarea::UpdateWishListDetails` fails because of a mongo index
    snafu, we can rescue the job and try resetting its details at a later
    time.

    WISHLISTS-81
    Tom Scott


Workarea Wish Lists 2.0.4 (2018-01-09)
--------------------------------------------------------------------------------

*   Add box component to users/accounts#show view

    WISHLISTS-113
    Curt Howard


Workarea Wish Lists 2.0.3 (2017-11-14)
--------------------------------------------------------------------------------

*   Fix wish list form serialization after switching SKUs

    WISHLISTS-111
    Ben Crouse

*   Correct BEM selector for wish-lists__link

    WISHLISTS-110
    Jake Beresford


Workarea Wish Lists 2.0.2 (2017-10-03)
--------------------------------------------------------------------------------

*   Remove duplicate DOM IDs

    WISHLISTS-108
    Curt Howard


Workarea Wish Lists 2.0.1 (2017-09-26)
--------------------------------------------------------------------------------

*   Add grid class to wish list summary in account dashboard

    WISHLISTS-106
    Ivana Veliskova

*   Remove jshint and replace with eslint WISHLISTS-102
    Dave Barnow


Workarea Wish Lists 2.0.0 (2017-05-19)
--------------------------------------------------------------------------------

*   Hide add to cart button on public wish list page when sku is not purchasable

    WISHLISTS-91
    Matt Duffy

*   Make adding to cart from wishlist UX match that of product details

    WISHLISTS-93
    Curt Howard

*   Properly handle a request for an invalid wish list

    WISHLISTS-98
    Matt Duffy

*   Correctly determine the purchasability of a wish list item

    WISHLISTS-91
    Matt Duffy

*   Rework wish list updating to ensure user details are set

    WISHLISTS-89
    Matt Duffy

*   Update for workare v3 compatibility

    WISHLISTS-89
    Matt Duffy


WebLinc Wish Lists 1.2.0 (2017-03-28)
--------------------------------------------------------------------------------

*   Add Link to storefront header to users wish list

    WISHLISTS-82
    Matt Duffy

*   Redirect to wish list when adding items to wish lists

    WISHLISTS-77
    Matt Duffy

*   Ensure purchase/unpurchased toggled remains visible on wish list pages

    WISHLISTS-76
    Matt Duffy


WebLinc Wish Lists 1.1.0 (2016-10-26)
--------------------------------------------------------------------------------

*   Romove varians n+1 queries when viewing a wishlist

    OrderItemViewModel was causing redundant queries to pricing and
    inventory.  Pass the inventory sku and collection to reduce product view
    model from making extra queries.  Don't extend OrderItemInventory at
    runtime since wish list item view model isn't pulling double duty like
    order item view model.

    WISHLISTS-85
    Eric Pigeon

*   Add customizations to wish list for logged out users.

    If a user is not logged in and they try to add an item to their wish list, we store the wish list item params in their session and then after they log in we redirect them to the wish list which triggers the item infor in the session to be added to their cart. However, the customizations for an item are not being copied to the wish list in this scenario. This commit adds the logic to store customizations in the session and add the customizations to the item.

    WISHLISTS-74
    Mike Dalton

*   Fix error for logged out user trying to move cart item to wish list.

    When a user is logged out and they try to move an item from their cart to their wish list, they are prompted to log in. After they log in, instead of being redirected to the wish list with the item move there they receive a 500 error. This commit fixes the issue by storing the cart item in the session and then redirecting to the wish list after the user logs in.

    WISHLISTS-72
    Mike Dalton

*   Update wish list stats to use site-specific databases if present

    Check if multisite plugin is installed, and use respective
    databases instead of default only.

    WISHLISTS-73
    Kristen Ward

*   Fix wish list stats reporter (QA)

    Updates commit 2959fb8dbe7079ada7384e15fa8e4cfad2c33500
    QA testing discovered that the worker updating the wish
    list stats is incorrectly looking within the admin.

    Move the worker and scheduled job to the same directory
    level as the wish lists stats module.

    WISHLISTS-69
    Kristen Ward

*   Fix add to cart button on manage wish list page

    Add to cart button in wish list item summaries throws
    an error. The path helper in the add to cart form supplies an
    unncessary argument. Remove this argument.

    Add test case

    WISHLISTS-71
    Kristen Ward

*   Schedule nightly update of wish list Stats

    Wish list stats never update, and nothing is telling
    them to do so. Add a worker and sidekiq cron scheduler to
    run build function in wish_list_stats.rb

    WISHLISTS-69
    Kristen Ward

*   Hide wish list share buttons when private

    Share buttons link to missing page when wish list is private.
    Toggle display of share buttons based on privacy to prevent this.

    WISHLISTS-70
    Kristen Ward

*   Disallow partial matching of email address on public search

    WISHLISTS-66
    Matt Duffy


WebLinc Wish Lists 1.0.5 (2016-08-31)
--------------------------------------------------------------------------------

*   Add customizations to wish list for logged out users.

    If a user is not logged in and they try to add an item to their wish list, we store the wish list item params in their session and then after they log in we redirect them to the wish list which triggers the item infor in the session to be added to their cart. However, the customizations for an item are not being copied to the wish list in this scenario. This commit adds the logic to store customizations in the session and add the customizations to the item.

    WISHLISTS-74
    Mike Dalton

*   Fix error for logged out user trying to move cart item to wish list.

    When a user is logged out and they try to move an item from their cart to their wish list, they are prompted to log in. After they log in, instead of being redirected to the wish list with the item move there they receive a 500 error. This commit fixes the issue by storing the cart item in the session and then redirecting to the wish list after the user logs in.

    WISHLISTS-72
    Mike Dalton


WebLinc Wish Lists 1.0.4 (2016-06-13)
--------------------------------------------------------------------------------

*   Update wish list stats to use site-specific databases if present

    Check if multisite plugin is installed, and use respective
    databases instead of default only.

    WISHLISTS-73
    Kristen Ward


WebLinc Wish Lists 1.0.3 (2016-04-26)
--------------------------------------------------------------------------------

*   Fix add to cart button on manage wish list page

    Add to cart button in wish list item summaries throws
    an error. The path helper in the add to cart form supplies an
    unncessary argument. Remove this argument.

    Add test case

    WISHLISTS-71
    Kristen Ward

*   Fix wish list stats reporter (QA)

    Updates commit 2959fb8dbe7079ada7384e15fa8e4cfad2c33500
    QA testing discovered that the worker updating the wish
    list stats is incorrectly looking within the admin.

    Move the worker and scheduled job to the same directory
    level as the wish lists stats module.

    WISHLISTS-69
    Kristen Ward

*   Schedule nightly update of wish list Stats

    Wish list stats never update, and nothing is telling
    them to do so. Add a worker and sidekiq cron scheduler to
    run build function in wish_list_stats.rb

    WISHLISTS-69
    Kristen Ward

*   Hide wish list share buttons when private

    Share buttons link to missing page when wish list is private.
    Toggle display of share buttons based on privacy to prevent this.

    WISHLISTS-70
    Kristen Ward


WebLinc Wish Lists 1.0.2 (2016-04-05)
--------------------------------------------------------------------------------


WebLinc Wish Lists 1.0.1 (2016-03-22)
--------------------------------------------------------------------------------

*   Disallow partial matching of email address on public search

    WISHLISTS-66
    Matt Duffy


WebLinc Wish Lists 1.0.0 (January 14, 2016)
--------------------------------------------------------------------------------

*   Update for compatibility with WebLinc 2.0

*   Replace absolute URLs with relative paths

*   Prevent inactive products from displaying in manage wish list view

    Update spec

    WISHLISTS-65

*   Show correct sku(s) for wishlist item on dashboard

    Update unit test

    WISHLISTS-65

*   Fix wishlist show markup

    Update indentation

    WISHLISTS-64


WebLinc Wish Lists 0.10.0 (October 7, 2015)
--------------------------------------------------------------------------------

*   Update plugin to be compatible with v0.12

    Update new & edit views, property work

    WISHLISTS-63

*   Add link depth css modifiers to admin menu.

    WISHLISTS-60

*   Fix translations that weren't displaying.

    WISHLISTS-59

    2984b035cad5c56b0f1151c57bb8d407b35ad307


WebLinc Wish Lists 0.9.0 (July 11, 2015)
--------------------------------------------------------------------------------

*   Update for compatibility with workarea 0.10.0.

    6ef9c0216b9f71af05f849d5a372031597a04b8f
    7e999a2b1e4a83171297ac3c76fb20a639a52892
    7a6c23325f2caaadbe0284a0cd2f5b876898dc1b
    44f5a65c489306968908560b7a90000691dc407e
    2aec2725a7405b67d93e05817de0125fcb263045

*   Remove Add to Cart button for $0 items.

    When an item is on the wish list but doesn't cost anything, don't allow
    the user to add that item to their cart. Follow the same rules as the
    "Add to Cart" button by checking for whether the product is in fact
    available for purchase as well. Non-purchasable products should not
    be allowed to add to cart.

    WISHLISTS-19

    f53ae89aa4f79446289b338769d190e87aab6965

*   Convert fixtures to factories compatible with workarea 0.9.

    WISHLISTS-58

    b13c83f39ab33a611494610dbb5f1af04e0c9768


WebLinc Wish Lists 0.8.0 (June 1, 2015)
--------------------------------------------------------------------------------

*   Update product -grid and -summary modifiers on dashboard to match changes
    in Store Front.

    WISHLISTS-57

*   Add missing submit button to quantity form.

    WISHLISTS-51

*   Update for compatibility with workarea 0.9.0.

    d3be34e2c689829571b01201291f8e7de6c9b065

*   Remove privacy conditional from user's own wish list view.

    WISHLISTS-52

*   Add `WORKAREA.wishListPublicQuantityFields` to update line item total on
    quantity change.

    WISHLISTS-42

*   Move wish lists API functionality from workarea-wish_lists to workarea-api.

    WISHLISTS-45

*   Add more sample data.

    WISHLISTS-32
    WISHLISTS-48


WebLinc Wish Lists 0.7.0 (April 10, 2015)
--------------------------------------------------------------------------------

*   Update JavaScript modules for compatibility with WebLinc 0.8.0.

*   Update testing environment for compatibility with WebLinc 0.8.0.

*   Use new decorator style for consistency with WebLinc 0.8.0.

*   Remove gems server secrets for consistency with WebLinc 0.8.0.

*   Remove `money_field` method for compatibility with WebLinc 0.8.0.

    WISHLISTS-41

*   Update assets for compatibility with WebLinc 0.8.0.

*   Add purchase details to wish list item when not logged in.

    Purchase details such as color and size were not being added to wish list if the user was not logged in when adding to wish list.

    WISHLISTS-40
