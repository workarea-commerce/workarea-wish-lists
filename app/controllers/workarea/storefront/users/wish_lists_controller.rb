module Workarea
  module Storefront
    class Users::WishListsController < Storefront::ApplicationController
      skip_before_action :verify_authenticity_token, only: [:add_item]
      before_action :store_item_in_session, only: :add_item, unless: :logged_in?
      before_action :store_item_in_session_when_moving_to_cart, only: :create_from_cart_item, unless: :logged_in?
      before_action :require_login_and_redirect
      before_action :add_item_from_session, only: :show, if: :item_stored_in_session?
      before_action :validate_customizations, only: :add_item

      def show
        WishList::Pricing.perform(current_wish_list)
        @wish_list = WishListViewModel.new(
          current_wish_list,
          view_model_options
        )
      end

      def update
        current_wish_list.update_attributes(params.permit(:privacy))
        flash[:success] =
          t('workarea.storefront.flash_messages.wish_list_updated')
        redirect_to users_wish_list_path
      end

      def update_item_quantity
        if current_wish_list.update_item_quantity(params[:item_id], params[:quantity].to_i)
          flash[:success] =
            t('workarea.storefront.flash_messages.wish_list_item_updated')
        end
        redirect_to users_wish_list_path
      end

      def create_from_cart_item
        item = current_order.items.find(params[:item_id])
        current_wish_list.add_item(
          item.product_id,
          item.sku,
          item.quantity,
          OrderItemDetails.find!(item.sku).to_h,
          item.customizations
        )
        current_order.remove_item(params[:item_id])

        flash[:success] =
          t('workarea.storefront.flash_messages.item_moved_to_wish_list')
        redirect_to users_wish_list_path
      end

      def add_item
        current_wish_list.add_item(
          product_id,
          sku,
          params[:quantity].to_i,
          OrderItemDetails.find!(sku).to_h,
          customizations.try(:to_h) || {}
        )
        flash[:success] =
          t('workarea.storefront.flash_messages.wish_list_item_added')
        redirect_to users_wish_list_path
      end

      def remove_item
        current_wish_list.remove_item(params[:sku])
        flash[:success] =
          t('workarea.storefront.flash_messages.wish_list_item_removed')
        redirect_to users_wish_list_path
      end

      private

      def require_login_and_redirect
        result = require_login
        remember_location(users_wish_list_path) if result == false
        result
      end

      def current_wish_list
        @wish_list ||= WishList.for_user(current_user.id)
      end

      def store_item_in_session
        wish_list_session.store_item(params.merge(customizations: customizations.try(:to_h) || {}))
      end

      def store_item_in_session_when_moving_to_cart
        item = current_order.items.where(id: params[:item_id]).first
        wish_list_session.store_item(item.attributes.merge(item_id: params[:item_id]))
      end

      def add_item_from_session
        item_id = cookies[:wish_list_item_id]

        wish_list_session.add_item(current_wish_list)
        current_order.remove_item(item_id) if current_order.items.where(id: item_id).present?
      end

      def wish_list_session
        WishListSession.new(cookies)
      end

      def item_stored_in_session?
        cookies.key?(:wish_list_product_id)
      end

      def customizations
        @customizations ||= Catalog::Customizations.find(product_id, params.to_unsafe_h)
      end

      def validate_customizations
        if customizations.present? && !customizations.valid?
          flash[:error] = customizations.errors.full_messages.join(', ')
          product = Catalog::Product.find(product_id)

          redirect_back(fallback_location: product_path(product))
          return false
        end
      end

      def product_id
        params[:product_id]
      end

      def sku
        params[:sku]
      end
    end
  end
end
