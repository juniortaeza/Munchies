//
//  LoginViewController.swift
//  munchies
//
//  Created by junior taeza on 12/2/22.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    // textfields
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // buttons
    @IBOutlet weak var loginButton: UIButton!
    
    // helper
    let util = Utility()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // beautify UI
        emailTextField.layer.borderColor = UIColor.black.cgColor
        emailTextField.layer.borderWidth = 0.75
        emailTextField.layer.cornerRadius = 5.0
        emailTextField.returnKeyType = UIReturnKeyType.done
        emailTextField.text = ""
        
        passwordTextField.layer.borderColor = UIColor.black.cgColor
        passwordTextField.layer.borderWidth = 0.75
        passwordTextField.layer.cornerRadius = 5.0
        passwordTextField.returnKeyType = UIReturnKeyType.done
        emailTextField.text = ""
        
        loginButton.layer.cornerRadius = 5.0
        
        // close keyboard on background tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // function for tap gesture recognizer
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // this function closes the keyboard when 'done' is tapped
    @IBAction func emailDismissKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    // this function closes the keyboard when 'done' is tapped
    @IBAction func passwordDismissKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    // this function is responsible for users signing into the app
    @IBAction func Login(_ sender: UIButton) {
        login()
    }
    
    // this helper function is invoked in Login
    func login() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            return
        }
        
        if email.count == 0 || password.count == 0 {
            let ac = util.alert(message: "Cannot leave fields blank.")
            self.present(ac, animated: true)
        } else {
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil {
                    let ac = self.util.alert(message: error?.localizedDescription ?? "")
                    self.present(ac, animated: true)
                    self.emailTextField.text = nil
                    self.passwordTextField.text = nil
                } else {
                    User.user.uid = (Auth.auth().currentUser?.uid)!
                    User.user.email = email
                    User.user.password = password
                    
                    let MainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = MainStoryboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
                    self.present(viewController, animated: true, completion: nil)
                }
            }
        }
    }
}
