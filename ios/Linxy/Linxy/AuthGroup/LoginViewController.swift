import UIKit

class LoginViewController: UIViewController {
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
 
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
  }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func onLogin(_ sender: Any) {
        let controller = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        //  let navigation = UINavigationController(rootViewController: controller)
        self.navigationController?.pushViewController(controller, animated: false)
    }
    
    @IBAction func goRegister(_ sender: Any) {
          let controller = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
              //  let navigation = UINavigationController(rootViewController: controller)
              self.navigationController?.pushViewController(controller, animated: false)
    }
}
