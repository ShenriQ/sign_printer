//  ViewController.swift
//  LinkReaderSample
//  Copyright (c) 2015 HP. All rights reserved.

// PD01KHN1546  Working
// PD01KHN1547  Not Working


import UIKit
import LinkReaderKit
import LinkReaderKit.LRPayoff
import LinkReaderKit.LRPresenter
import AudioToolbox

class HomeVC: UIViewController, EasyReadingDelegate, LRPresenterDelegate, UIAlertViewDelegate {
    
    let disabledColor = UIColor(red: 196/255.0, green: 196/255.0, blue: 196/255.0, alpha: 1)
    let enabledColor = UIColor(red: 17/255.0 , green: 130/255.0, blue: 203/255.0, alpha: 1)
    let testClientID = Constants.testClientID
    let testSecrete = Constants.testSecreteKey
    var presenter : LRPresenter!
    var readerObject : EasyReadingViewController!
    
    @IBOutlet weak var authErrorLabel : UILabel!
    @IBOutlet weak var startScanningButton : UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var bgImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getLaunchImageName()
        importRenderFram()
        for view in self.readerObject.view.subviews {
            if (view is UIImageView)  {
                let imgview: UIImageView? = (view as? UIImageView)
                imgview?.image = nil
                
            }
        }
    }
    func initBackgoundImageView(){
        if UIDevice.current.userInterfaceIdiom == .pad {
            print("ipad")
            self.bgImageView.image = UIImage.init(named: "bg_ipad")
        } else  {
            print("Iphone")
            self.bgImageView.image = UIImage.init(named: "bg_iphone")
        }
    }
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.rotationImage(withSize: size)
    }
    func getLaunchImageName() -> String? {
        let allPngImageNames = Bundle.main.paths(forResourcesOfType: "png", inDirectory: nil)
        let expression = "SELF contains '\("LaunchImage")'"
        let res = (allPngImageNames as NSArray).filtered(using: NSPredicate(format: expression))
        var launchImageName: String = ""
        for launchImage in res {
            do {
                if let img = UIImage(named: (launchImage as? String ?? "")) {
                    // Has image same scale and dimensions as our current device's screen?
                    if img.scale == UIScreen.main.scale && (img.size.equalTo(UIScreen.main.bounds.size)) {
                        // The image with the Current Screen Resolution
                        launchImageName = launchImage as? String ?? ""
                        print("hurrry Image Name...:-\(launchImageName)")
                        self.bgImageView.image = UIImage.init(named: launchImageName)
                        break
                    }
                }
            }
        }
        return launchImageName
    }
    func rotationImage(withSize:CGSize) -> String {
        let allPngImageNames = Bundle.main.paths(forResourcesOfType: "png", inDirectory: nil)
        let expression = "SELF contains '\("LaunchImage")'"
        let res = (allPngImageNames as NSArray).filtered(using: NSPredicate(format: expression))
        var launchImageName: String = ""
        for launchImage in res {
            do {
                if let img = UIImage(named: (launchImage as? String ?? "")) {
                    // Has image same scale and dimensions as our current device's screen?
                    if img.scale == UIScreen.main.scale && (img.size.equalTo(withSize)) {
                        // The image with the Current Screen Resolution
                        launchImageName = launchImage as? String ?? ""
                        print("Get Image Name...:-\(launchImageName)")
                        self.bgImageView.image = UIImage.init(named: launchImageName)
                        break
                    } else {
                        if UIDevice.current.userInterfaceIdiom == .pad {
                            
                            
                        } else {
                            if UIDevice.current.orientation.isLandscape {
                                print("Get Not Hurry ")
                                self.bgImageView.image = UIImage.init(named: "iPhoneLandScap")
                                break
                            }
                        }
                    }
                }
            }
        }
        return launchImageName
    }
   
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        Utils.lockOrientation(.all)
    }
    func importRenderFram(){
        self.readerObject = EasyReadingViewController(clientID: testClientID, secret: testSecrete, delegate: self, success: {
            self.activityIndicator.stopAnimating()
            self.readerObject.view.frame = self.view.bounds
            let navigationObject = UINavigationController(rootViewController: self.readerObject)
            self.readerObject.navigationController?.isNavigationBarHidden = true
            self.present(navigationObject, animated: true) { () -> Void in
                self.readerObject.forceDoneButtonHidden(true)
                self.readerObject.addingViewToBottum(isHide: false)
            }
        }, failure: { (error) in
            print("The Debug Error:-",error.debugDescription)
            self.displayAuthErrorToUser(error)
        })
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func launchLinkReaderSDK(_ button: UIButton) {
        self.readerObject.view.frame = self.view.bounds
        self.present(self.readerObject, animated: true) { () -> Void in
        }
    }
    deinit {
        importRenderFram()
    }
    func displayAuthErrorToUser(_ error : Error?) {
        // Handle authentication errors!!! ... Below code is just a placeholder, your app must handle these appropiately
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        if let authError = error as NSError? {
            switch authError.code {
            case LRAuthorizationError.networkError.rawValue:
                alertController.message = "There is a problem connecting with the server. error: " + authError.localizedDescription
                alertController.title = "Network Error"
                alertController.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action) in
                    self.activityIndicator.startAnimating()
                    self.readerObject.reauthenticate(success: { () -> Void in
                        self.activityIndicator.stopAnimating()
                        self.startScanningButton.isEnabled = true
                        self.startScanningButton.backgroundColor = self.enabledColor
                    }, failure: { (error : Error?) -> Void in
                        // Authentication or Network Error
                        self.displayAuthErrorToUser(error)
                    })
                }))
            case LRAuthorizationError.apiKeyInvalid.rawValue:
                alertController.message = "The API key used was not valid: " + authError.localizedDescription
                alertController.title = "Auth Error"
            default:
                alertController.message = "There was an authentication error: " + authError.localizedDescription
                alertController.title = "Error"
            }
        }else{
            alertController.message = "There was an authentication error"
            alertController.title = "Error"
        }
        self.present(alertController, animated: true, completion: nil)
        self.activityIndicator.stopAnimating()
    }
    
    func showAuthorizationErrorMessage() {
        self.authErrorLabel.isHidden = false
        self.startScanningButton.isHidden = true
    }
    
    //Mark : EasyReadingDelegate methods
    
    func readerError(_ error: Error!) {
        let nsError  = error as NSError
        // Handle reader errors!!! ... Below code is just a placeholder, your app must handle these appropiately
        var errorCode = ""
        if (nsError.domain == LRPayoffResolverErrorDomain) {
            
            switch (nsError.code) {
            case LRPayoffResolverError.serverError.rawValue:
                errorCode = "LRPayoffResolverErrorServerError"
            case LRPayoffResolverError.payloadNotFound.rawValue:
                errorCode = "LRPayoffResolverErrorPayloadNotFound"
            case LRPayoffResolverError.payloadOutOfRange.rawValue:
                errorCode = "LRPayoffResolverErrorPayloadOutOfRange"
            case LRPayoffResolverError.badResolveRequest.rawValue:
                errorCode = "LRPayoffResolverErrorBadResolveRequest"
            case LRPayoffResolverError.connectionError.rawValue:
                errorCode = "LRPayoffResolverErrorConnectionError"
            case LRPayoffResolverError.requestCancelled.rawValue:
                errorCode = "LRPayoffResolverErrorRequestCancelled"
            case LRPayoffResolverError.networkConnectionLost.rawValue:
                errorCode = "LRPayoffResolverErrorNetworkConnectionLost"
            case LRPayoffResolverError.networkRequestTimedOut.rawValue:
                errorCode = "LRPayoffResolverErrorNetworkRequestTimedOut"
            case LRPayoffResolverError.notAuthorized.rawValue:
                errorCode = "LRPayoffResolverErrorNotAuthorized"
            default:
                errorCode = "Unexpected Code"
            }
        }
        else if (nsError.domain == LRPayoffErrorDomain) {
            switch (nsError.code) {
            case LRPayoffError.payoffNotPresentInData.rawValue:
                errorCode = "LRPayoffErrorPayoffNotPresentInData"
            case LRPayoffError.invalidPayoffData.rawValue:
                errorCode = "LRPayoffErrorInvalidPayoffData"
            case LRPayoffError.missingOrUnknownPayoffType.rawValue:
                errorCode = "LRPayoffErrorMissingOrUnknownPayoffType"
            case LRPayoffError.invalidPayoffFormat.rawValue:
                errorCode = "LRPayoffErrorInvalidPayoffFormat"
            default:
                errorCode = "Unexpected Code"
            }
        }
        let message = "Error while detecting mark: \(nsError.domain) - \(errorCode)"
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.readerObject.resumeScanning()
        }))
        self.readerObject.present(alert, animated: true, completion: nil)
    }
    
    func handle(_ payoff:LRPayoff) -> Bool {
        if (payoff is LRPayoffBase) {
            let validatePayoff: LRPayoffBase = payoff as! LRPayoffBase
            var payoffType: String = "Unknown"
            if (payoff is LRLayoutPayoff) {
                payoffType = "Rich";
            } else if (payoff is LRHtmlPayoff) {
                payoffType = "Html";
            } else if (payoff is LRWebPayoff) {
                payoffType = "Web URL";
            } else if (payoff is ARPayoff) {
                payoffType = "AR";
            } else if (payoff is LRCustomDataPayoff) {
                payoffType = "Custom Data";
            }
            if payoffType == "Web URL" {
                print("the data is:-\(payoff.displayString())")
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CutsomWebViewVC") as! CutsomWebViewVC
                controller.getURL = payoff.displayString()
                self.readerObject.navigationController?.pushViewController(controller, animated: true)
                return true;
            } else {
                if (self.presenter == nil) {
                    self.presenter = LRPresenter()
                    self.presenter.delegate = self
                }
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                self.presenter.present(payoff, viewController: self.readerObject)
                return true;
            }
        } else {
            return false;
        }
    }
    
    func presentationDidDismiss() {
        self.readerObject.resumeScanning()
        Utils.lockOrientation(.all)
    }
}

//MARK:- Extension of a class to implement Custom Fuctionality
//MARK:-

@objc extension EasyReadingViewController {
    
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            //print("Landscape")
            
            if UIDevice.current.orientation.isFlat {
               // print("Flat")
            }
        } else {
            //print("Portrait")
            
            //addingViewToBottum(isHide:false)
        }
        addingViewToBottum(isHide: false)
    }
    override open func viewWillDisappear(_ animated: Bool) {
        //print("\n calling its")
    }
    
    func addingViewToBottum(isHide:Bool) {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            var firstTime = true
            for views in self.view.subviews{
                if(views.tag == 12345){
                    firstTime = false
                    views.removeFromSuperview()
                }
            }
            let bottumView = UIView()
            bottumView.tag = 12345
            var buttonY = UIScreen.main.bounds.size.width-80
            if(firstTime){
                buttonY = UIScreen.main.bounds.size.height-80
            }
            if(UIDevice.current.orientation.isPortrait){
                bottumView.frame = CGRect(x: 15, y: buttonY, width: 60, height: 50)
            }else{
                bottumView.frame = CGRect(x: 15, y: buttonY, width: 60, height: 50)
            }
            //print("ButtonY:-\(buttonY)")
            bottumView.backgroundColor = UIColor.clear
            self.view.frame = self.view.bounds
            self.view.addSubview(bottumView)
            self.view.bringSubviewToFront(bottumView)
            bottumView.isHidden = isHide
            
            let btnClick = UIButton()
            btnClick.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            btnClick.backgroundColor = UIColor.clear
            btnClick.setTitleColor(.white, for: .normal)
            btnClick.layer.cornerRadius = 5
            btnClick.clipsToBounds = true
            btnClick.setBackgroundImage(UIImage.init(named:"menu"), for: .normal)
            btnClick.addTarget(self, action: #selector(menuButtonClick), for: .touchUpInside)
            bottumView.addSubview(btnClick)
            bottumView.isUserInteractionEnabled = true
            
        } else {
            var firstTime = true
            for views in self.view.subviews{
                if(views.tag == 12345){
                    firstTime = false
                    views.removeFromSuperview()
                }
            }
            
            let bottumView = UIView()
            bottumView.tag = 12345
            var buttonY = UIScreen.main.bounds.size.width-80
            if(firstTime){
                buttonY = UIScreen.main.bounds.size.height-80
            }
            if(UIDevice.current.orientation.isPortrait){
                bottumView.frame = CGRect(x: 15, y: buttonY, width: 60, height: 50)
            }else{
                bottumView.frame = CGRect(x: 15, y: buttonY, width: 60, height: 50)
            }
            bottumView.backgroundColor = UIColor.clear
            self.view.frame = self.view.bounds
            self.view.addSubview(bottumView)
            self.view.bringSubviewToFront(bottumView)
            bottumView.isHidden = isHide
            
            let btnClick = UIButton()
            btnClick.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            btnClick.backgroundColor = UIColor.clear
            btnClick.setTitleColor(.white, for: .normal)
            btnClick.layer.cornerRadius = 5
            btnClick.clipsToBounds = true
            btnClick.setBackgroundImage(UIImage.init(named:"menu"), for: .normal)
            btnClick.addTarget(self, action: #selector(menuButtonClick), for: .touchUpInside)
            bottumView.addSubview(btnClick)
            bottumView.isUserInteractionEnabled = true
        }
    }
    
    @objc func menuButtonClick() {
        self.toCreateActionSheet()
    }
    func getMainStoryboard()-> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    func toCreateActionSheet() {
        
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        //to change font of title and message.
        let titleFont = [NSAttributedString.Key.font: UIFont(name: "ArialHebrew-Bold", size: 18.0)!]
        //let messageFont = [NSAttributedString.Key.font: UIFont(name: "Avenir-Roman", size: 12.0)!]
        let titleAttrString = NSMutableAttributedString(string: "Select Option", attributes: titleFont)
        //let messageAttrString = NSMutableAttributedString(string: "Message Here", attributes: messageFont)
        actionSheetController.setValue(titleAttrString, forKey: "attributedTitle")
        //actionSheetController.setValue(messageAttrString, forKey: "attributedMessage")
        
        let firstAction: UIAlertAction = UIAlertAction(title: "How-to & Privacy", style: .default) { action -> Void in
            /* let controller = self.getMainStoryboard().instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
             controller.navigationController?.pushViewController(controller, animated: true) */
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
            //  let navigation = UINavigationController(rootViewController: controller)
            self.navigationController?.pushViewController(controller, animated: false)
            
        }
        let secondAction: UIAlertAction = UIAlertAction(title: "Terms of Service", style: .default) { action -> Void in
           /* let controller = self.getMainStoryboard().instantiateViewController(withIdentifier: "HelpVC") as! HelpVC
            controller.navigationController?.pushViewController(controller, animated: true)
            */
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HelpVC") as! HelpVC
//            let navigation = UINavigationController(rootViewController: controller)
            self.navigationController?.pushViewController(controller, animated: false)
        }
        
        let thirdAction: UIAlertAction = UIAlertAction(title: "Attributions", style: .default) { action -> Void in
            
            /*let controller = self.getMainStoryboard().instantiateViewController(withIdentifier: "AttributionVC") as! AttributionVC
            controller.navigationController?.pushViewController(controller, animated: true)
            */
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AttributionVC") as! AttributionVC
            // let navigation = UINavigationController(rootViewController: controller)
            self.navigationController?.pushViewController(controller, animated: false)
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        firstAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        secondAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        thirdAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        actionSheetController.view.tintColor = UIColor.black
        actionSheetController.view.backgroundColor = UIColor.white
        actionSheetController.view.layer.cornerRadius = 10
        
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(thirdAction)
        actionSheetController.addAction(cancelAction)
        
        actionSheetController.popoverPresentationController?.sourceView = self.view
        present(actionSheetController, animated: true) {
            
        }
    }
}
