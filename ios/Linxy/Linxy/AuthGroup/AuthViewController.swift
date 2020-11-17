import UIKit

class AuthViewController: UIViewController {
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
    @IBOutlet weak var register_button: UIButton!
    @IBOutlet weak var login_button: UIButton!
    
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
//    register_button.isHidden = true
//    login_button.isHidden = true
//
//    if manager.currentUserID().isNone == false {
//
//        manager.currentUserData() {result in
//             print(result?.role)
//            let vc = UIStoryboard.initial(storyboard:
//                result?.role == "Customer" ?
//                .conversations : .supplier_dash)
//
//            vc.modalPresentationStyle = .fullScreen
//            self.present(vc, animated: true)
//        }
//    }
//    else
//    {
//
//        register_button.isHidden = false
//        login_button.isHidden = false
//    }
  }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    @IBAction func goLogin(_ sender: Any) {
//        let vc = UIStoryboard.initial(storyboard:  .login)
//            vc.modalPresentationStyle = .fullScreen
//            present(vc, animated: true)
    }
    @IBAction func goRegister(_ sender: Any) {
//        let vc = UIStoryboard.initial(storyboard: .register)
//            vc.modalPresentationStyle = .fullScreen
//            present(vc, animated: true)
    }
    
    
}
