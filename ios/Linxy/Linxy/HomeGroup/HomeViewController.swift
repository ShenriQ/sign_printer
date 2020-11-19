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
    
    @IBAction func goMyLinxyMarks(_ sender: Any) {
        let controller = UIStoryboard(name: "MyLinxyMarks", bundle: nil).instantiateViewController(withIdentifier: "MyLinxyMarksViewController") as! MyLinxyMarksViewController
        //  let navigation = UINavigationController(rootViewController: controller)
        self.navigationController?.pushViewController(controller, animated: false)
    }
    
    @IBAction func onScan(_ sender: Any) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
               //  let navigation = UINavigationController(rootViewController: controller)
               self.navigationController?.pushViewController(controller, animated: false)
    }
    
}
