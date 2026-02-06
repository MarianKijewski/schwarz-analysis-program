sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"com/schwarz/providerportal/test/integration/pages/MyRequestsList",
	"com/schwarz/providerportal/test/integration/pages/MyRequestsObjectPage"
], function (JourneyRunner, MyRequestsList, MyRequestsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('com/schwarz/providerportal') + '/test/flpSandbox.html#comschwarzproviderportal-tile',
        pages: {
			onTheMyRequestsList: MyRequestsList,
			onTheMyRequestsObjectPage: MyRequestsObjectPage
        },
        async: true
    });

    return runner;
});

