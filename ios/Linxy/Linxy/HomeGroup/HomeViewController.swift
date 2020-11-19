import UIKit

class HomeViewController: UIViewController {
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
    
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

  }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @IBAction func onCreate(_ sender: Any) {
        let controller = UIStoryboard(name: "Create", bundle: nil).instantiateViewController(withIdentifier: "CreateViewController") as! CreateViewController
               //  let navigation = UINavigationController(rootViewController: controller)
               self.navigationController?.pushViewController(controller, animated: false)
    }
    
}
