require 'workarea'
require 'workarea/storefront'
require 'workarea/admin'

require 'workarea/testing/factories/wish_lists' if Rails.env.test?

module Workarea
  module WishLists
  end
end

require 'workarea/wish_lists/version'
require 'workarea/wish_lists/engine'
