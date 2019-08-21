module Workarea
  module WishLists
    class Engine < ::Rails::Engine
      include Workarea::Plugin
      isolate_namespace Workarea::WishLists

      config.before_configuration do
        Rails.application
             .config
             .action_dispatch
             .rescue_responses['Workarea::WishList::InvalidToken'] = :not_found
      end
    end
  end
end
