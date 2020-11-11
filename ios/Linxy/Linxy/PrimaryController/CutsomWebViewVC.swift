//  CutomWebViewVC.swift
//  Linxy
//  Created by tekzee on 04/09/19.
//  Copyright © 2019 tekzee. All rights reserved.

import UIKit
import WebKit
import AVFoundation
import AVKit
class CutsomWebViewVC: UIViewController {

    @IBOutlet weak var btnCustom: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var btnLeft: UIButton!
    
    @IBOutlet weak var btnHeight: NSLayoutConstraint!
    @IBOutlet weak var btnWidth: NSLayoutConstraint!
    
    var webView = WKWebView()
    var activityIndicator: UIActivityIndicatorView!
    var getURL = ""
    var count = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        btnCustom.isHidden = true
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        if #available(iOS 10.0, *) {
            configuration.mediaTypesRequiringUserActionForPlayback = []
        }
        configuration.preferences.javaScriptEnabled = true
        webView = WKWebView(frame: .zero, configuration: configuration)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        
    }
    
    @IBAction func rightAction(_ sender: UIButton) {
        getURL = ""
        if UIDevice.current.userInterfaceIdiom == .pad{
            Utils.lockOrientation(.all, andRotateTo: .portrait)
        } else {
            Utils.lockOrientation(.all, andRotateTo: .portrait)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func leftAction(_ sender: UIButton) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            let value = UIInterfaceOrientation.landscapeRight.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            Utils.lockOrientation(.landscapeRight)
        } else {
            let value = UIInterfaceOrientation.landscapeRight.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            Utils.lockOrientation(.landscapeRight)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            createWebViewForiPad()
            self.btnHeight.constant = 40.0
            self.btnWidth.constant = 40.0
        } else {
            self.btnWidth.constant = 30.0
            self.btnHeight.constant = 30.0
            createWebView()
        }
    }
    func createWebView(){
        self.navigationController?.isNavigationBarHidden = true
        if UIDevice.current.orientation.isLandscape {
            
            webView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            if UIDevice.current.orientation.isFlat {
            }
        } else {
            webView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.height, height: UIScreen.main.bounds.size.width)
        }
        self.updateViewConstraints()        
        webView.backgroundColor = .white
        view.addSubview(webView)
        view.bringSubviewToFront(btnCustom)
        view.bringSubviewToFront(btnRight)
        view.bringSubviewToFront(btnLeft)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        let myURL = URL(string: getURL)
        let myRequest = URLRequest(url: myURL!)
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
        webView.load(myRequest)
    }
    
    func createWebViewForiPad(){
        self.navigationController?.isNavigationBarHidden = true
        if UIDevice.current.orientation.isLandscape {
            
            webView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            if UIDevice.current.orientation.isFlat {
                
            }
        } else {
            webView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        }
        self.updateViewConstraints()
        webView.backgroundColor = .white
        view.addSubview(webView)
        view.bringSubviewToFront(btnCustom)
        view.bringSubviewToFront(btnRight)
        view.bringSubviewToFront(btnLeft)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        let myURL = URL(string: getURL)
        let myRequest = URLRequest(url: myURL!)
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
        webView.load(myRequest)
    }
    func showActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            if UIDevice.current.orientation.isLandscape {
                webView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
                if UIDevice.current.orientation.isFlat {
                    
                }
            } else {
                webView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            }
            self.updateViewConstraints()
        }
    }
}

//MARK:- Webview Delegate Method
//MARK:-

extension CutsomWebViewVC: WKUIDelegate,WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showActivityIndicator(show: true)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showActivityIndicator(show: false)
        view.bringSubviewToFront(btnCustom)
        view.bringSubviewToFront(btnRight)
        view.bringSubviewToFront(btnLeft)
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        showActivityIndicator(show: false)
        print("The Web View HTML url:--",webView.url ?? "")
        //showActivityIndicator(show: true)
        let url1 = Utils.returnStringFor(value: webView.url)
        let videoExtension = ["mp4"]
        let url: URL? = URL(string: url1) //  NSURL(fileURLWithPath: url1) as URL
        let pathExtention = url?.pathExtension
        if videoExtension.contains(pathExtention!) {
            if count == 1 {
                let getUrldata = Utils.returnStringFor(value:url)
                let newURl = getUrldata + "?playsinline=1"
                let myURL = URL(string: newURl)
                let myRequest = URLRequest(url: myURL!)
                view.bringSubviewToFront(btnCustom)
                view.bringSubviewToFront(btnRight)
                view.bringSubviewToFront(btnLeft)
                webView.load(myRequest)
            } else {
                
            }
            count = count + 1
        } else {
            print("Image URL: \(String(describing: url))")
        }
        showActivityIndicator(show: false)
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showActivityIndicator(show: false)
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
       
        if navigationAction.navigationType == .linkActivated  {
            if let url = navigationAction.request.url,
                let host = url.host,UIApplication.shared.canOpenURL(url) {
                print("NavigationAction url:-\(url)")
                let myRequest = URLRequest(url: url)
                activityIndicator = UIActivityIndicatorView()
                activityIndicator.center = self.view.center
                activityIndicator.hidesWhenStopped = true
                activityIndicator.style = UIActivityIndicatorView.Style.gray
                view.addSubview(activityIndicator)
                webView.load(myRequest)
                decisionHandler(.allow)
                /*let absoluteStr = url.absoluteString
                if !absoluteStr.contains("http://"){
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                    decisionHandler(.cancel)
                } else {
                    decisionHandler(.allow)
                }*/
            } else {
                print("Open it locally")
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
        }
    }
    func showLinksClicked(subURL:String){
        Utils.showAlertWithMessage(message: subURL, onViewController: self)
    }
}
/*
extension AVPlayerViewController {
    func addButton() {
        let btn = UIButton(type: .roundedRect)
        btn.backgroundColor = UIColor.red
//        btn.setTitle("Do stuff", for: .normal)
        btn.setImage(UIImage(named: "btnBarcode"), for: .normal)
        let screenWidth = UIScreen.main.bounds.size.width
        btn.frame = CGRect(x: 0, y: (screenWidth-50)/2, width: 50, height: 50)
        btn.addTarget(self, action: #selector(self.pressButton(button:)), for: .touchUpInside)
        btn.isUserInteractionEnabled = true
        btn.isEnabled = true
        btn.clipsToBounds = true
        
        self.contentOverlayView?.addSubview((btn as? UIButton)!)
        self.showsPlaybackControls = false
    }
    
    @objc func pressButton(button: UIButton) {
        if let appDele = UIApplication.shared.delegate as? AppDelegate{
           Utils.lockOrientation(.all, andRotateTo: .portrait)
            appDele.window?.rootViewController?.navigationController?.popViewController(animated: true)
        }
    }
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
}*/
