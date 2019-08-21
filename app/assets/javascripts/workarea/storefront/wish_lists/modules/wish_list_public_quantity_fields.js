/**
 * @namespace WORKAREA.wishListPublicQuantityFields
 */
WORKAREA.registerModule('wishListPublicQuantityFields', (function () {
    'use strict';

    var convertPriceToCents = function (textPrice) {
            return parseInt(textPrice) * 100;
        },

        calculateTotalPrice = function (priceAsText, quantity) {
            var total = convertPriceToCents(priceAsText) * quantity;
            return total/100;
        },

        totalPrice = function (price, quantity) {
            return '$' + calculateTotalPrice(price, quantity).toFixed(2);
        },

        updateItemTotalPrice = function (event) {
            var $item = $(event.currentTarget).closest('tr'),
                $itemPrice = $item.find('.wish-lists__public-item-price'),
                $itemTotal = $item.find('.wish-lists__public-total-price'),
                quantity = $item.find('.wish-lists__public-quantity-field').val(),
                price = $itemPrice.text().replace('$', '');

            $itemTotal.text(totalPrice(price, quantity));
        },

        /**
         * @method
         * @name init
         * @memberof WORKAREA.wishListPublicQuantityFields
         */
        init = function ($scope) {
            $('.wish-lists__public-quantity-field', $scope).on('change', updateItemTotalPrice);
        };

    return {
        init: init
    };
}()));
