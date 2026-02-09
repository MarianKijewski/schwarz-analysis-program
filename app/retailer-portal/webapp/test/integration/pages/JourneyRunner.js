sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"com/schwarz/retailerportal/test/integration/pages/MyRequestsList",
	"com/schwarz/retailerportal/test/integration/pages/MyRequestsObjectPage"
], function (JourneyRunner, MyRequestsList, MyRequestsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('com/schwarz/retailerportal') + '/test/flpSandbox.html#comschwarzretailerportal-tile',
        pages: {
			onTheMyRequestsList: MyRequestsList,
			onTheMyRequestsObjectPage: MyRequestsObjectPage
        },
        async: true
    });

    return runner;
});

