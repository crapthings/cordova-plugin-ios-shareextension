var exec = require('cordova/exec')

var shareextension = {}

shareextension.onFiles = function (onSuccess, onError) {
  exec(onSuccess, onError, 'ShareExtension', 'onFiles', [])
}

module.exports = shareextension
