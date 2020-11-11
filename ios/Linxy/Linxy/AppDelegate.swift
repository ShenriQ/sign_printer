//  AppDelegate.swift
//  Linxy
//  Copyright © 2019 tekzee. All rights reserved.

//Apple Developer account Login Credential

//Apple ID:- alankar.kashyap@tekzee.com
//Password:- Managepass1

import UIKit
import LinkReaderKit
import LinkReaderKit.LRPayoff
import LinkReaderKit.LRPresenter
import AudioToolbox
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate ,EasyReadingDelegate{
   
    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.all
    let testClientID = Constants.testClientID
    let testSecrete = Constants.testSecreteKey
    var presenter : LRPresenter!
    var readerObject : EasyReadingViewController!
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //importRenderFram()
        return true
    }
    func importRenderFram(){
        self.readerObject = EasyReadingViewController(clientID: testClientID, secret: testSecrete, delegate: self, success: {
            self.readerObject.view.frame = UIScreen.main.bounds
            let navigationObject = UINavigationController(rootViewController: self.readerObject)
            self.readerObject.navigationController?.isNavigationBarHidden = true
            self.window?.rootViewController?.present(navigationObject, animated: true, completion: nil)
            //appDelegate.window?.rootViewController = navigationObject
            /*present(navigationObject, animated: true) { () -> Void in
                
            }*/
        }, failure: { (error) in
        })
    }
    func readerError(_ error: Error!) {
        
    }
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
       
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    } 
}

