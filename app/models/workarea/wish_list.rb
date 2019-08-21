module Workarea
  class WishList
    include Mongoid::Document
    include Mongoid::Timestamps
    include UrlToken

    class InvalidToken < StandardError; end

    field :user_id, type: String
    field :email, type: String
    field :first_name, type: String
    field :last_name, type: String
    field :name, type: String
    field :location, type: String
    field :privacy, type: String, default: 'public'

    index({ user_id: 1 }, { unique: true })
    index(first_name: 1)
    index(last_name: 1)
    index(name: 1)
    index(email: 1)

    index(token: 1, privacy: 1)

    embeds_many :items, class_name: 'Workarea::WishList::Item'

    validates :privacy,
              presence: true,
              inclusion: { in: %w(public shared private) }

    scope :named, -> { where(:name.exists => true, :name.ne => '') }

    before_create :set_user_details

    # Gets a wish list for a user.
    #
    # @param [String] user_id
    #
    # @return [WishList]
    #
    def self.for_user(user_id)
      existing = Workarea::WishList.where(user_id: user_id).first
      existing || Workarea::WishList.create!(user_id: user_id)
    end

    # Find wish lists for public viewing.
    # Only returns wish lists with public privacy setting.
    #
    # @param [String] query
    #   name or email
    # @param [String] location
    #   city, state, postal code
    #
    # @return [Array]
    #
    def self.search(query, location = '')
      Workarea::WishList::PublicSearch.new(
        query,
        location
      ).results
    end

    # Find a wish list by the share token
    #
    # @param [String] token
    #
    # @return [WishList]
    #
    def self.find_by_token(token)
      raise(InvalidToken, token) if token.blank?

      Workarea::WishList.where(
        token: token,
        :privacy.ne => 'private'
      ).first || raise(InvalidToken, token)
    end

    # Find a list of product ids in a user's wish list
    #
    # @param [String, BSON::ObjectId] user_id
    #
    # @return [Array]
    #
    def self.find_products(user_id)
      wish_list = Workarea::WishList.where(user_id: user_id).first
      wish_list ? wish_list.items.map(&:product_id) : []
    end

    %w(public shared private).each do |privacy_level|
      define_method "#{privacy_level}?" do
        privacy == privacy_level
      end
    end

    # How many valid units are in the wish list
    #
    # @return [Integer]
    #
    def quantity
      items.select(&:valid?).sum(&:quantity)
    end

    # Get unpurchased items
    #
    # @return [Array]
    #
    def unpurchased_items
      items.reject(&:purchased?)
    end

    # Get items from this list that have been purchased
    #
    # @return [Array]
    #
    def purchased_items
      items.select(&:purchased?)
    end

    # Add a wish list item
    #
    # @param [String] product_id
    # @param [String] sku
    # @param [Integer] quantity
    #
    # @return [Boolean]
    #   whether the item was saved
    #
    def add_item(product_id, sku, quantity = 1, details = {}, customizations = {})
      if existing_item = items.where(sku: sku, customizations: customizations).first
        change_quantity(sku, existing_item.quantity + quantity)
      else
        items.build(
          product_id:     product_id,
          sku:            sku,
          quantity:       quantity,
          details:        details,
          customizations: customizations
        )
      end

      save
    end

    # Update a wish list item's quantity
    #
    # @param [String] item_id
    # @param [Integer] quantity
    #
    # @return [Boolean]
    #   whether the item was saved
    #

    def update_item_quantity(item_id, quantity)
      item = items.where(id: item_id).first
      return false if item.nil?
      item.update_attributes(quantity: quantity)
    end

    # Mark the items as being purchased
    #
    # @param [Array] skus
    #
    # @return [self]
    #
    def mark_item_purchased(sku, quantity)
      item = items.detect { |i| i.sku == sku }
      if item
        item.received = item.received + quantity
        item.purchased = true
      end
      save!
    end

    # Remove a SKU from the wish list
    #
    # @param [String] sku
    #
    # @return [self]
    #
    def remove_item(sku)
      items.where(sku: sku).first.delete
      save
    end

    def price_adjustments
      PriceAdjustmentSet.new(
        (items.map(&:price_adjustments).flatten || [])
      )
    end

    def reset_pricing!
      items.each(&:reset_pricing!)
      self
    end

    def segment_ids
      []
    end

    private

    def change_quantity(sku, quantity)
      item = items.where(sku: sku).first
      item.quantity = quantity
    end

    def set_user_details
      return unless user_id.present?
      SetWishListDetails.new(self).perform
    end
  end
end
