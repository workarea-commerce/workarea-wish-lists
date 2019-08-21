/**
 * @method
 * @name registerAdapter
 * @memberof WORKAREA.analytics
 */
WORKAREA.analytics.registerAdapter('wish_lists', function () {
    'use strict';

    return {
        'addToWishList': function (payload) {
            if (payload.id) {
                $.ajax({
                    type: 'POST',
                    url: WORKAREA.routes.storefront.analyticsWishListAddPath(
                        { product_id: payload.id }
                    ),
                });
            }
        },
        'removeFromWishList': function (payload) {
            if (payload.id) {
                $.ajax({
                    type: 'POST',
                    url: WORKAREA.routes.storefront.analyticsWishListRemovePath(
                        { product_id: payload.id }
                    ),
                });
            }
        }
    };
});
