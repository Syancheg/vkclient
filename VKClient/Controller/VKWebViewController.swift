//
//  VKWevViewController.swift
//  VKClient
//
//  Created by Константин Кузнецов on 27.11.2020.
//

import UIKit
import WebKit

class VKWebViewController: UIViewController {
    
    // MARK: - Outlets
//    lazy var firebase = FirebaseService()
    
    @IBOutlet weak var webview: WKWebView!{
        didSet{
            webview.navigationDelegate = self
        }
    }
    
    // MARK: - Life Circle

    override func viewDidLoad() {
        super.viewDidLoad()
        getAuthorizationPage()
    }
    
    // MARK: - Load page
    
    func getAuthorizationPage(){
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
                urlComponents.host = "oauth.vk.com"
                urlComponents.path = "/authorize"
                urlComponents.queryItems = [
                    URLQueryItem(name: "client_id", value: "7679529"),
                    URLQueryItem(name: "display", value: "mobile"),
                    URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
                    URLQueryItem(name: "scope", value: "friends,photos,groups,wall"),
//                    URLQueryItem(name: "revoke", value: "1"),
                    URLQueryItem(name: "response_type", value: "token"),
                    URLQueryItem(name: "v", value: "5.68")
                ]
                
                let request = URLRequest(url: urlComponents.url!)
                
        webview.load(request)

    }

}

extension VKWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {

        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        

        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value

                return dict
        }
        let token = params["access_token"]
        let session = Session.start
        session.token = token ?? ""
        session.userId = params["user_id"] ?? ""
//        firebase.saveUserId()
        
        // MARK: - Seque

        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "StartController") as! UITabBarController
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:true, completion:nil)

        decisionHandler(.cancel)
    }
}
