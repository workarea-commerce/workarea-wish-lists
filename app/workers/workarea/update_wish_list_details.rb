module Workarea
  class UpdateWishListDetails
    include Sidekiq::Worker
    include Sidekiq::CallbacksWorker

    sidekiq_options(
      enqueue_on: { User => :save },
      unique: :until_executing
    )

    def perform(user_id)
      wish_list = Workarea::WishList.for_user(user_id)
      SetWishListDetails.new(wish_list).perform!
    rescue Mongo::Error::OperationFailure => error
      raise error unless error.message =~ /E11000 duplicate key error collection/
      logger.warn "Duplicate key error, WishList with user_id=#{user_id} already exists."
    end
  end
end
