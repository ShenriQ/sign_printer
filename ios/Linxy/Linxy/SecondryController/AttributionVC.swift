//HelpVC.swift
//Linxy
//Copyright © 2019 tekzee. All rights reserved.

import UIKit
import WebKit

class AttributionVC: UIViewController {
    var webView = WKWebView()
    var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        Utils.lockOrientation(.portrait)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            createWebViewForiPad()
        } else {
            createWebViewWithoutRotation()
        }
    }
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            if UIDevice.current.orientation.isLandscape {
                
                webView.frame = CGRect(x: 0, y: 70, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
                if UIDevice.current.orientation.isFlat {
                    
                }
            } else {
                webView.frame = CGRect(x: 0, y: 70, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            }
            self.updateViewConstraints()
        }
    }
    func loadHtmlContent(){
        let url = Bundle.main.url(forResource: "AttributionCode", withExtension:"html")
        let request = NSURLRequest(url: url!)
        webView.load(request as URLRequest)
    }
    func showActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    @IBAction func backAction(_ sender: UIButton) {
        Utils.lockOrientation(.all, andRotateTo: .portrait)
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- Create View Without Rotation
//MARK:-

extension AttributionVC {
    
    func createWebViewWithoutRotation(){
        self.navigationController?.isNavigationBarHidden = true
        if UIDevice.current.orientation.isLandscape {
            webView.frame = CGRect(x: 0, y: 70, width: UIScreen.main.bounds.size.height, height: UIScreen.main.bounds.size.width)
            if UIDevice.current.orientation.isFlat {
            }
        } else {
            webView.frame = CGRect(x: 0, y: 70, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        }
        self.updateViewConstraints()
        webView.backgroundColor = .lightGray
        view.addSubview(webView)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
        
        /*let urlSTR = "https://1a1.me/res/attribution/"
        let myURL = URL(string: urlSTR)
        let myRequest = URLRequest(url: myURL!)
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
        webView.load(myRequest)*/
        loadHtmlContent()
    }
    func createWebViewForiPad(){
        self.navigationController?.isNavigationBarHidden = true
        if UIDevice.current.orientation.isLandscape {
            webView.frame = CGRect(x: 0, y: 70, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            if UIDevice.current.orientation.isFlat {
                
            }
        } else {
            webView.frame = CGRect(x: 0, y: 70, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            print("In Potrait Fram Width:\(UIScreen.main.bounds.size.width)")
            print("In Potrait Fram Height:\(UIScreen.main.bounds.size.height)")
            
        }
        self.updateViewConstraints()
        self.updateViewConstraints()
        webView.backgroundColor = .lightGray
        view.addSubview(webView)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
        
        /*let urlSTR = "https://1a1.me/res/attribution/"
        let myURL = URL(string: urlSTR)
        let myRequest = URLRequest(url: myURL!)
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
        webView.load(myRequest)*/
        
        loadHtmlContent()
    }
}



//MARK:- Webview Delegate Method
//MARK:-

extension AttributionVC: WKUIDelegate,WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("didStartProvisionalNavigation")
        showActivityIndicator(show: true)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinish")
        showActivityIndicator(show: false)
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        showActivityIndicator(show: false)
        decisionHandler(.allow)
        print("decidePolicyFor navigationResponse:")
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("didFail navigation")
    }
    
    //MARK:- To Navigate Other Screen
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated  {
            if let myURL = navigationAction.request.url,
                UIApplication.shared.canOpenURL(myURL) {
                print("\n The Clicked URL:==\(myURL)")
                /*let myRequest = URLRequest(url: myURL)
                activityIndicator = UIActivityIndicatorView()
                activityIndicator.center = self.view.center
                activityIndicator.hidesWhenStopped = true
                activityIndicator.style = UIActivityIndicatorView.Style.gray
                view.addSubview(activityIndicator)
                webView.load(myRequest)*/
                decisionHandler(.cancel)
            } else {
                print("Open it locally")
                decisionHandler(.allow)
            }
        } else {
            print("not a user click")
            decisionHandler(.allow)
        }
    }
}

