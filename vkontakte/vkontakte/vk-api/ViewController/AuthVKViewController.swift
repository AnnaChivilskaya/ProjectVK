//
//  AuthViewController.swift
//  vkontakte
//
//  Created by Аня on 31.01.2022.
//

//import UIKit
//import WebKit
//import Kingfisher
//
//class AuthVKViewController: UIViewController {
//
//    var session = Session.instance
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        webView.navigationDelegate = self
//        loadAuthVK()
//    }
//
//    @IBOutlet weak var webView: WKWebView!
//
//
//    func loadAuthVK() {
//
//        var urlConstructor = URLComponents()
//        urlConstructor.scheme = "https"
//        urlConstructor.host = "oauth.vk.com"
//        urlConstructor.path = "/authorize"
//        urlConstructor.queryItems = [
//            URLQueryItem(name: "client_id", value: "8120234"),
//            URLQueryItem(name: "display", value: "mobile"),
//            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
//            URLQueryItem(name: "scope", value: "friends,photos,groups,wall"),
//            URLQueryItem(name: "response_type", value: "token"),
//            URLQueryItem(name: "v", value: "5.131")
//        ]
//
//        guard let url = urlConstructor.url  else { return }
//        let request = URLRequest(url: url)
//
//        webView.load(request)
//    }
//
//
//    func removeCookie() {
//        let cookieStore = webView.configuration.websiteDataStore.httpCookieStore
//
//        cookieStore.getAllCookies {
//            cookies in
//            for cookie in cookies {
//                cookieStore.delete(cookie)
//            }
//        }
//    }
//
//}
//
//
//extension AuthVKViewController: WKNavigationDelegate {
//    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
//
//
//        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
//            decisionHandler(.allow)
//            return
//        }
//
//        let params = fragment
//            .components(separatedBy: "&")
//            .map { $0.components(separatedBy: "=") }
//            .reduce([String : String]()) { result, param in
//                var dict = result
//                let key = param[0]
//                let value = param[1]
//                dict[key] = value
//                return dict
//        }
//
//        {
//            if let token = params["access_token"], let userID = params["user_id"], let expiresIn = params["expires_in"] {
//                self.session.token = token
//                self.session.userId = Int(userID) ?? 0
//                self.session.expiredDate = Date(timeIntervalSinceNow: TimeInterval(Int(expiresIn) ?? 0))
//
//                decisionHandler(.cancel)
//
//
//                self.performSegue(withIdentifier: "AuthVKY", sender: nil)
//            } else {
//                decisionHandler(.allow)
//
//                self.performSegue(withIdentifier: "AuthVKN", sender: nil)
//            }
//
//        }
//    }
//}
//


