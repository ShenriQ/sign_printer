//
//  Utils.swift
//  Linxy
//
//  Created by tekzee on 07/09/19.
//  Copyright © 2019 tekzee. All rights reserved.
//


import UIKit
import Foundation

class Utils: NSObject {
    
    static let appName = "Linxy"
    typealias AlertComplitionhandler = ()->Void
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        self.lockOrientation(orientation)
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    static func returnStringFor(value:Any?) -> String {
        if(value is NSNull)
        {
            return ""
        } else if(value == nil) {
            return ""
        } else if(value is String) {
            return (value as? String) ?? "\(value ?? "")"
        } else {
            return "\(value ?? "")"
        }
    }
    static func showAlertWithMessage(message msgStr: String, onViewController controller: UIViewController) {
        let alert = UIAlertController(title: appName, message: msgStr, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(alertAction)
        controller.present(alert, animated: true, completion: nil)
    }
    static func showAlertWithHandeler(message msgStr: String, onViewController controller: UIViewController, withComplitionhandler: @escaping AlertComplitionhandler) {
        let alert = UIAlertController(title: appName, message: msgStr, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel) { (okAction) in
            withComplitionhandler()
        }
        alert.addAction(alertAction)
        controller.present(alert, animated: true, completion: nil)
    }
}
/*extension UINavigationController {
    
    open override var shouldAutorotate: Bool {
        return true
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return (visibleViewController?.supportedInterfaceOrientations)!
    }
}*/
