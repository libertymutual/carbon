var exec = require('cordova/exec');

var TouchIdPlugin = {
	supportsTouchId : function (successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "TouchIdPlugin", "supportsTouchID", []);
	},
	getCredentialsFromKeychain : function (successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "TouchIdPlugin", "getCredentialsFromKeychain", []);
	},
	setCredentialsInKeychain : function (successCallback, errorCallback, username, password) {
		cordova.exec(successCallback, errorCallback, "TouchIdPlugin", "setCredentialsInKeychain", [username,
			password]);
	},
	deleteCredentialsInKeychain : function (successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "TouchIdPlugin", "deleteCredentialsInKeychain", []);
	}
};

module.exports = TouchIdPlugin;
