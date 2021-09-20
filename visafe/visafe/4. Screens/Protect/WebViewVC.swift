import UIKit
import WebKit

class WebViewVC: BaseViewController {
    @IBOutlet weak var webview: WKWebView!
    var url: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let _url = url, let myURL = URL(string: _url) else {
            return
        }
        let myRequest = URLRequest(url: myURL)
        webview.load(myRequest)
        self.title = "Tiện ích bảo mật"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
}
