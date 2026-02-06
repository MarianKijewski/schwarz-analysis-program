sap.ui.define([
    "sap/ui/test/opaQunit",
    "./pages/JourneyRunner"
], function (opaTest, runner) {
    "use strict";

    function journey() {
        QUnit.module("First journey");

        opaTest("Start application", function (Given, When, Then) {
            Given.iStartMyApp();

            Then.onTheS_OrdersList.iSeeThisPage();
            Then.onTheS_OrdersList.onTable().iCheckColumns(3, {"producer":{"header":"Supplier Name"},"customerEmail":{"header":"Email"},"status":{"header":"Onboarding Status"}});

        });


        opaTest("Navigate to ObjectPage", function (Given, When, Then) {
            // Note: this test will fail if the ListReport page doesn't show any data
            
            When.onTheS_OrdersList.onFilterBar().iExecuteSearch();
            
            Then.onTheS_OrdersList.onTable().iCheckRows();

            When.onTheS_OrdersList.onTable().iPressRow(0);
            Then.onTheS_OrdersObjectPage.iSeeThisPage();

        });

        opaTest("Teardown", function (Given, When, Then) { 
            // Cleanup
            Given.iTearDownMyApp();
        });
    }

    runner.run([journey]);
});