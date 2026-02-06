sap.ui.define([
    "sap/m/MessageToast"
], function(MessageToast) {
    'use strict';

    return {
        submitOrder: function(oEvent) {
            const oContext = oEvent.getSource().getBindingContext();
            const oModel = oContext.getModel();
            const sPath = oContext.getPath();

            // Use the context path to build the action binding
            const oActionContext = oModel.bindContext(sPath + "/MessengerService.submitOrder(...)");
            
            oActionContext.execute()
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
