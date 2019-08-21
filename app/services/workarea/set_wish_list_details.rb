module Workarea
  class SetWishListDetails
    def initialize(wish_list)
      @wish_list = wish_list
    end

    def perform
      return unless user.present?

      @wish_list.attributes = {
        email: user.email,
        first_name: user.first_name,
        last_name: user.last_name,
        name: user.name,
        location: location_for(user.default_billing_address)
      }
    end

    def perform!
      perform && @wish_list.save!
    end

    private

    def user
      @user ||= Workarea::User.find(@wish_list.user_id)
    rescue Mongoid::Errors::DocumentNotFound, Mongoid::Errors::InvalidFind
      nil
    end

    # TODO: Remove in next major version
    #
    # @deprecated
    def name_for(user)
      [user.first_name, user.last_name].join(' ').strip
    end

    def location_for(address)
      return '' if address.blank?

      [
        address.city,
        address.region,
        address.country.alpha2,
        address.postal_code
      ].join(' ').strip
    end
  end
end
