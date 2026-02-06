sap.ui.define(['sap/fe/test/ListReport'], function(ListReport) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ListReport(
        {
            appId: 'manageorders',
            componentId: 'S_OrdersList',
            contextPath: '/S_Orders'
        },
        CustomPageDefinitions
    );
});