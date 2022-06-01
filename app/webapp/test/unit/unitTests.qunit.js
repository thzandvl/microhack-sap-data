/* global QUnit */
QUnit.config.autostart = false;

sap.ui.getCore().attachInit(function () {
	"use strict";

	sap.ui.require([
		"dsag/de/bupabrowser/test/unit/AllTests"
	], function () {
		QUnit.start();
	});
});