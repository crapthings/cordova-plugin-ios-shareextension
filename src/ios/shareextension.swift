@objc(ShareExtension) class ShareExtension: CDVPlugin {
    var _command: CDVInvokedUrlCommand?

    override func pluginInitialize() {
        super.pluginInitialize()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(sendUrls),
            name: NSNotification.Name("CDVPluginHandleOpenURLNotification"),
            object: nil
        )
    }

    @objc func sendUrls() {
        let userDefaults = UserDefaults(suiteName: "group.com.idibwofa6eg9w4.bk46f44qira.shareextension")!
        let urls = userDefaults.array(forKey: "urls")
        let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: urls)
        result!.keepCallback = true
        self.commandDelegate.send(result, callbackId: _command!.callbackId!)
    }

    @objc(onFiles:) func onFiles(command: CDVInvokedUrlCommand) {
        self._command = command
    }
}
