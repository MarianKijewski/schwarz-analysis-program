sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"com/schwarz/supplierportal/test/integration/pages/MyRequestsList",
	"com/schwarz/supplierportal/test/integration/pages/MyRequestsObjectPage"
], function (JourneyRunner, MyRequestsList, MyRequestsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('com/schwarz/supplierportal') + '/test/flp.html#app-preview',
        pages: {
			onTheMyRequestsList: MyRequestsList,
			onTheMyRequestsObjectPage: MyRequestsObjectPage
        },
        async: true
    });

    return runner;
});

