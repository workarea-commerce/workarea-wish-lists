/**
 * @namespace WORKAREA.wishListButton
 */
WORKAREA.registerModule('wishListButton', (function () {
    'use strict';

    var redirectToWishList = function() {
            window.location = WORKAREA.routes.storefront.usersWishListPath();
        },
        addItemToWishList = function(event) {
            var $button = $(event.currentTarget),
                action = WORKAREA.routes.storefront.addToUsersWishListPath(),
                $form = $button.closest('.product-details')
                               .find('.product-details__add-to-cart-form'),
                payload = $form.serialize();

            event.preventDefault();

            if ($form.valid()) {
                $.post(action, payload, redirectToWishList);
            }
        },
        /**
         * @method
         * @name init
         * @memberof WORKAREA.wishListButton
         */
        init = function($scope) {
            $('[data-wish-list-button]', $scope).on('click', addItemToWishList);
        };

    return {
        init: init
    };
}()));
