sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"manageorders/test/integration/pages/S_OrdersList",
	"manageorders/test/integration/pages/S_OrdersObjectPage"
], function (JourneyRunner, S_OrdersList, S_OrdersObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('manageorders') + '/test/flp.html#app-preview',
        pages: {
			onTheS_OrdersList: S_OrdersList,
			onTheS_OrdersObjectPage: S_OrdersObjectPage
        },
        async: true
    });

    return runner;
});

