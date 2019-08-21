module Workarea
  module Storefront
    class WishListsController < Storefront::ApplicationController
      def index
        if params[:wish_list_query].present?
          @wish_lists = WishList
                        .search(params[:wish_list_query], params[:location])
                        .page(params[:page] || 1)
        end
      end

      def show
        wish_list = WishList.find_by_token(params[:id])
        WishList::Pricing.perform(wish_list)
        @wish_list = WishListViewModel.new(
          wish_list,
          view_model_options
        )
      end
    end
  end
end
