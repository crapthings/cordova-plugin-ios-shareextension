import MobileCoreServices
import UIKit

class ShareViewController: UIViewController {
    @IBOutlet weak var textarea: UITextView!
    @IBOutlet weak var done: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        let bundleIdentifier = Bundle.main.bundleIdentifier!
        let userDefaults = UserDefaults(suiteName: "group.\(bundleIdentifier)")!
        let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.\(bundleIdentifier)")

        var urls: [String] = []

        guard let extensionItems = extensionContext?.inputItems as? [NSExtensionItem] else {
            return
        }

        let group = DispatchGroup()

        for extensionItem in extensionItems {
            if let itemProviders = extensionItem.attachments {
                for itemProvider in itemProviders {
                    group.enter()
                    itemProvider.loadItem(forTypeIdentifier: kUTTypeItem as String, options: nil, completionHandler: { url, error in
                        let sourceUrl: URL = url as! URL
                        let filename = sourceUrl.lastPathComponent
                        let extname = sourceUrl.pathExtension
                        let newname = "\(UUID().uuidString).\(extname)"
                        let targetUrl = (containerURL?.appendingPathComponent(newname))!
                        do {
                            try FileManager.default.copyItem(at: sourceUrl, to: targetUrl)
                            urls.append("\(targetUrl)")
                            group.leave()
                        } catch {}
                    })
                }
            }
        }

        group.notify(queue: .main) {
            userDefaults.set(urls, forKey: "urls")
            userDefaults.synchronize()
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
