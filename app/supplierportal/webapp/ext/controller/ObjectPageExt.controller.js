sap.ui.define([
    "sap/ui/core/mvc/ControllerExtension",
    "sap/m/Dialog",
    "sap/m/VBox",
    "sap/m/Text",
    "sap/m/Input",
    "sap/m/Button",
    "sap/m/MessageBox",
    "sap/ui/core/BusyIndicator"
], function (ControllerExtension, Dialog, VBox, Text, Input, Button, MessageBox, BusyIndicator) {
    "use strict";

    return ControllerExtension.extend("com.schwarz.supplierportal.ext.controller.ObjectPageExt", {
        override: {
            onInit: function() {
                // Θολώνουμε τη σελίδα αμέσως μόλις ξεκινήσει
                this.base.getView().addStyleClass("portalLocked");
                this._bVerified = false;
            },
            onAfterRendering: function () {
                if (!this._bVerified) {
                    this._showPasscodeDialog();
                }
            }
        },

        _showPasscodeDialog: function () {
            const oView = this.base.getView();
            this._oDialog = new Dialog({
                title: "Security Verification",
                type: "Message",
                state: "Warning",
                content: new VBox({
                    items: [
                        new Text({ text: "Enter your passcode so to see the order details:" }),
                        new Input("passcodeInput", { type: "Password", placeholder: "Passcode..." })
                    ]
                }),
                beginButton: new Button({
                    text: "Unlock",
                    press: function () {
                        this._verifyPasscode();
                    }.bind(this)
                }),
                escapeHandler: function() {} 
            });
            this._oDialog.open();
        },

        _verifyPasscode: function () {
            const sCode = sap.ui.getCore().byId("passcodeInput").getValue();
            const oModel = this.base.getModel();
            const oContext = this.base.getView().getBindingContext();
            
            // Παίρνουμε το ID του supplier από το τρέχον REQ
            const sSupplierID = oContext.getProperty("supplier_ID");

            BusyIndicator.show(0);
            const oAction = oModel.bindContext("/verifyPasscode(...)");
            oAction.setParameter("supplierID", sSupplierID);
            oAction.setParameter("passcode", sCode);

            oAction.execute().then(function () {
                BusyIndicator.hide();
                if (oAction.getBoundContext().getObject().value === true) {
                    this._bVerified = true;
                    // Αφαιρούμε το θόλωμα μόνο αν ο κωδικός είναι σωστός
                    this.base.getView().removeStyleClass("portalLocked");
                    this._oDialog.close();
                    this._oDialog.destroy();
                } else {
                    MessageBox.error("Wrong Passcode");
                }
            }.bind(this)).catch(function (err) {
                BusyIndicator.hide();
                MessageBox.error("Connnection error: " + err.message);
            });
        }
    });
});