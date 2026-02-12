sap.ui.define(['sap/fe/test/ListReport'], function(ListReport) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ListReport(
        {
            appId: 'com.schwarz.app.documents',
            componentId: 'DocumentsList',
            contextPath: '/Documents'
        },
        CustomPageDefinitions
    );
});