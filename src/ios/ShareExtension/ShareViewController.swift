import MobileCoreServices
import UIKit

class ShareViewController: UIViewController {
    @IBOutlet weak var textarea: UITextView!
    @IBOutlet weak var done: UIButton!

    let userDefaults = UserDefaults(suiteName: "group.com.idibwofa6eg9w4.bk46f44qira.shareextension")!
    let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.idibwofa6eg9w4.bk46f44qira.shareextension")

    override func viewDidLoad() {
        super.viewDidLoad()

        var urls: [String] = []

        guard let extensionItems = extensionContext?.inputItems as? [NSExtensionItem] else {
            return
        }

        let group = DispatchGroup()

        for extensionItem in extensionItems {
            if let itemProviders = extensionItem.attachments {
                for itemProvider in itemProviders {
                    group.enter()
                    itemProvider.loadItem(forTypeIdentifier: kUTTypeItem as String, options: nil, completionHandler: { text, error in
                        let sourceUrl: URL = text as! URL
                        let filename = (text as! URL).lastPathComponent
                        let extname = sourceUrl.pathExtension
                        let newname = "\(UUID().uuidString).\(extname)"
                        let targetUrl = self.containerURL?.appendingPathComponent(newname)
                        do {
                            try FileManager.default.copyItem(at: sourceUrl, to: targetUrl!)
                            urls.append("\(targetUrl!)")
                            group.leave()
                        } catch {}
                    })
                }
            }
        }

        group.notify(queue: .main) {
            self.userDefaults.set(urls, forKey: "urls")
            self.userDefaults.synchronize()
            self.textarea.insertText("\(urls)\n\n")
            self.openURL(URL(string:"openwith://test")!)
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        }
    }

    @IBAction func btn(_ sender: UIButton) {
        self.openURL(URL(string:"openwith://test")!)
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    @objc func openURL(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application.perform(#selector(openURL(_:)), with: url) != nil
            }
            responder = responder?.next
        }
        return false
    }
}
