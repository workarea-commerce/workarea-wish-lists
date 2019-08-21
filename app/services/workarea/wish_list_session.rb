module Workarea
  # WishListSession is responsible for storing a representation of a product that will later be added to a user's Wish List.
  #
  class WishListSession
    attr_reader :session

    # @param [Hash] user's Session
    def initialize(session)
      @session = session
    end

    # Store a form-posted representation of a Wish List Item. This would include the product_id, sku and quantity of that item.
    #
    # @param [Hash] controller's params
    #
    # @return [void]
    def store_item(params)
      collection_keys.each do |key|
        session["wish_list_#{key}"] = params[key] if params[key].present?
      end
    end

    # Add the current item in the session to a the given wish list.
    #
    # @param [WishList]
    #
    # @return [void]
    def add_item(wish_list)
      product_id = session['wish_list_product_id']
      sku = session['wish_list_sku']
      quantity = session['wish_list_quantity']
      customizations = session['wish_list_customizations']

      wish_list.add_item(
        product_id,
        sku,
        quantity.to_i,
        OrderItemDetails.find!(sku).to_h,
        customizations || {}
      )

      collection_keys.each do |key|
        session.delete("wish_list_#{key}")
      end
    end

    private

    def collection_keys
      %w(item_id product_id sku quantity customizations)
    end
  end
end
