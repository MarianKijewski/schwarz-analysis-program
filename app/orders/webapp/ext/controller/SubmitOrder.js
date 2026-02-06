sap.ui.define([
    "sap/m/MessageToast"
], function(MessageToast) {
    'use strict';

    return {
        submitOrder: function(oEvent) {
            const oContext = oEvent.getSource().getBindingContext();
            const oModel = oContext.getModel();
            const sOrderID = oContext.getProperty("ID");

            oModel.bindContext(`/S_Orders(${sOrderID})/MessengerService.submitOrder(...)`).execute()
                .then(function(oResult) {
                    MessageToast.show("Order submitted successfully!");
                    oModel.refresh();
                })
                .catch(function(oError) {
                    MessageToast.show("Error submitting order: " + oError.message);
                });
        }
    };
});
