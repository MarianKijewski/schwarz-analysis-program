sap.ui.define([
    "sap/m/Dialog",
    "sap/m/VBox",
    "sap/m/Text",
    "sap/m/Input",
    "sap/m/Button",
    "sap/m/MessageBox",
    "sap/ui/core/BusyIndicator"
], function (Dialog, VBox, Text, Input, Button, MessageBox, BusyIndicator) {
    "use strict";

    return {
        onUnlockPress: function (oEvent) {
            const oView = oEvent.getSource().Routing.getView();
            const sHash = window.location.hash;
            const sID = sHash.split("supplierID=")[1]?.split("&")[0];

            const oDialog = new Dialog({
                title: "Security Check",
                content: new VBox({
                    items: [
                        new Text({ text: "Εισάγετε τον κωδικό πρόσβασης:" }),
                        new Input("passcodeInput", { type: "Password" })
                    ]
                }),
                beginButton: new Button({
                    text: "Unlock",
                    press: function () {
                        const sCode = sap.ui.getCore().byId("passcodeInput").getValue();
                        const oModel = oView.getModel();
                        
                        BusyIndicator.show(0);
                        const oAction = oModel.bindContext("/verifyPasscode(...)");
                        oAction.setParameter("supplierID", sID);
                        oAction.setParameter("passcode", sCode);

                        oAction.execute().then(function () {
                            BusyIndicator.hide();
                            if (oAction.getBoundContext().getObject().value === true) {
                                oDialog.close();
                                MessageBox.success("Το Portal ξεκλείδωσε!");
                                oModel.refresh(); // Ανανέωση δεδομένων
                            } else {
                                MessageBox.error("Λάθος κωδικός.");
                            }
                        }).catch(err => {
                            BusyIndicator.hide();
                            MessageBox.error(err.message);
                        });
                    }
                }),
                endButton: new Button({ text: "Άκυρο", press: () => oDialog.close() }),
                afterClose: () => oDialog.destroy()
            });
            oDialog.open();
        }
    };
});