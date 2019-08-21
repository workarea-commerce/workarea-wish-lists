Workarea Wish Lists
================================================================================

A Workarea Commerce plugin to allow customers to create, manage, share, and search wish lists.

Overview
--------------------------------------------------------------------------------

* Add products to a wish list from the product details page or cart
* Manage list privacy - public, shared, or private
* Manage wish list items
* View products purchased from the wish lists
* Search public wish lists by customer's name or email address
* Add products to cart from wish lists
* Admin view of a customer's wish list items and purchase state

Getting Started
--------------------------------------------------------------------------------

Add the gem to your application's Gemfile:

```ruby
# ...
gem 'workarea-wish_lists'
# ...
```

Update your application's bundle.

```bash
cd path/to/application
bundle
```

Features
--------------------------------------------------------------------------------

### Creating and managing wish lists

A customer can manage a list of products associated to their account. These products can be added from the product detail page directly, or from the cart. Wish list items maintain quantity, option, and customization selections for easy addition to orders at a later time. Quantity can be changed from the wish list page.

### Privacy Control

A customer has control over the privacy level of their wish list. Setting a wish list to `public` allows other visitors of the site to search by a user's full name or email address and view a wish list, as well as purchase items off the wish list. Lists set to `shared` are not searchable but can be viewed by other visitors of the site if given a direct link to the wish list by the customer. A `private` wish list can be viewed only by the customer that owns the list.

### Add to cart from wish list

An item can be added to a customer's cart from their own wish list or a wish list they have searched for / been given a link to view. Items purchased from the list will be marked as purchased.

Workarea Commerce Documentation
--------------------------------------------------------------------------------

See [https://developer.workarea.com](https://developer.workarea.com) for Workarea Commerce documentation.

License
--------------------------------------------------------------------------------

Workarea Wish Lists is released under the [Business Software License](LICENSE)
