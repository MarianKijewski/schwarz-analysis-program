sap.ui.define([
    "sap/ui/test/opaQunit",
    "./pages/JourneyRunner"
], function (opaTest, runner) {
    "use strict";

    function journey() {
        QUnit.module("First journey");

        opaTest("Start application", function (Given, When, Then) {
            Given.iStartMyApp();

            Then.onTheMyRequestsList.iSeeThisPage();
            Then.onTheMyRequestsList.onTable().iCheckColumns(6, {"requestNumber":{"header":"Request Number"},"description":{"header":"Description"},"pageCount":{"header":"Page Count"},"extractionConfidence":{"header":"Confidence"},"requestDate":{"header":"Date"},"status":{"header":"Status"}});

        });


        opaTest("Navigate to ObjectPage", function (Given, When, Then) {
            // Note: this test will fail if the ListReport page doesn't show any data
            
            When.onTheMyRequestsList.onFilterBar().iExecuteSearch();
            
            Then.onTheMyRequestsList.onTable().iCheckRows();

            When.onTheMyRequestsList.onTable().iPressRow(0);
            Then.onTheMyRequestsObjectPage.iSeeThisPage();

        });

        opaTest("Teardown", function (Given, When, Then) { 
            // Cleanup
            Given.iTearDownMyApp();
        });
    }

    runner.run([journey]);
});