sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"com/schwarz/app/documents/test/integration/pages/DocumentsList",
	"com/schwarz/app/documents/test/integration/pages/DocumentsObjectPage"
], function (JourneyRunner, DocumentsList, DocumentsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('com/schwarz/app/documents') + '/test/flp.html#app-preview',
        pages: {
			onTheDocumentsList: DocumentsList,
			onTheDocumentsObjectPage: DocumentsObjectPage
        },
        async: true
    });

    return runner;
});

