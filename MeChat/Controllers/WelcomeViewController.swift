import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        sender.setTitleColor(UIColor.systemPink, for: .highlighted)
        sender.setBackgroundColor(color: UIColor.systemPink, forState: .highlighted)
        
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        sender.setTitleColor(UIColor.systemPink, for: .highlighted)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerButton.layer.cornerRadius = 25
        registerButton.clipsToBounds = true
        registerButton.layer.borderColor = CGColor(red: 1.000, green: 0.137, blue: 0.459, alpha: 1.000)
        registerButton.layer.borderWidth = 1.5
        registerButton.setBackgroundColor(color: UIColor.systemPink, forState: UIControl.State.highlighted)
        
        loginButton.layer.cornerRadius = 25
        loginButton.clipsToBounds = true
        loginButton.layer.borderColor = CGColor(red: 1.000, green: 0.137, blue: 0.459, alpha: 1.000)
        loginButton.layer.borderWidth = 1.5
        loginButton.setBackgroundColor(color: UIColor.systemPink, forState: UIControl.State.highlighted)
        
        
        
        
        
        
        
        titleLabel.text = ""
        var charIndex = 0.0
        let titleText = K.appName
        for letter in titleText {
            print("------------------")
            print(0.1 * charIndex)
            print(letter)
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }
        
    }
    
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        self.clipsToBounds = true  // add this to maintain corner radius
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }
}
