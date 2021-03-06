import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet var register: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        register.layer.cornerRadius = 25
        register.clipsToBounds = true
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print("error: \(e)")
                } else {
                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
                }
                
            }
        }
        
    }
    
}
