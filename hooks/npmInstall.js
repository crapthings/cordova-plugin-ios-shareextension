const PLUGIN_ID = 'cordova-plugin-ios-shareextension'

module.exports = function (context) {
  var childProcess = require('child_process')
  var deferral = require('q').defer()

  console.log('Installing "' + PLUGIN_ID + '" dependencies')

  childProcess.exec('npm install --production', { cwd: __dirname }, function (error) {
    if (error !== null) {
      console.log('exec error: ' + error)
      deferral.reject('npm installation failed')
    }

    deferral.resolve()
  })

  return deferral.promise
}
