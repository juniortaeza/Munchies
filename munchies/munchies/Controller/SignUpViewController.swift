//
//  LoginViewController.swift
//  munchies
//
//  Created by junior taeza on 12/2/22.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    // textfields
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    // buttons
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if App.app.appAlreadyConfigured == false {
            FirebaseApp.configure()
            App.app.appAlreadyConfigured = true
        }
        
        // beautify UI
        emailTextField.layer.borderColor = UIColor.black.cgColor
        emailTextField.layer.borderWidth = 0.75
        emailTextField.layer.cornerRadius = 5.0
        emailTextField.returnKeyType = UIReturnKeyType.done
        
        passwordTextField.layer.borderColor = UIColor.black.cgColor
        passwordTextField.layer.borderWidth = 0.75
        passwordTextField.layer.cornerRadius = 5.0
        passwordTextField.returnKeyType = UIReturnKeyType.done
        
        confirmPasswordTextField.layer.borderColor = UIColor.black.cgColor
        confirmPasswordTextField.layer.borderWidth = 0.75
        confirmPasswordTextField.layer.cornerRadius = 5.0
        confirmPasswordTextField.returnKeyType = UIReturnKeyType.done
        
        signUpButton.layer.cornerRadius = 5.0
        loginButton.layer.cornerRadius = 5.0
        
        // close keyboard on background tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // this function dismisses the keyboard when the background is tapped
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // this function dismisses the keyboard when the keyboard's 'done' is tapped
    @IBAction func emailDismissKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    // this function dismisses the keyboard when the keyboard's 'done' is tapped
    @IBAction func passwordDismissKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    // this function dismisses the keyboard when the keyboard's 'done' is tapped
    @IBAction func confirmPasswordDismissKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    // this is a helper function to display and alert when something goes wrong
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }
    
    // this action is responsible for signing users up to the App
    @IBAction func SignUp(_ sender: UIButton) {
        signup()
    }
    
    // this is a helper function that implements @IBAction SignUp
    func signup() {
        guard let email = emailTextField.text,
              let password1 = passwordTextField.text,
              let password2 = confirmPasswordTextField.text else {
            return
        }
        
        if email.count == 0 || password1.count == 0 || password2.count == 0 {
            alert(message: "Cannot leave fields blank.")
        } else if password1 != password2 {
            alert(message: "Passwords do not match.")
            passwordTextField.text = nil
            confirmPasswordTextField.text = nil
        } else {
            Auth.auth().createUser(withEmail: email, password: password2) { (result, error) in
                if error != nil {
                    self.alert(message: error?.localizedDescription ?? "")
                    self.emailTextField.text = nil
                    self.passwordTextField.text = nil
                    self.confirmPasswordTextField.text = nil
                } else {
                    User.user.uid = (Auth.auth().currentUser?.uid)!
                    User.user.email = email
                    User.user.password = password2
                    
                    let MainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = MainStoryboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
                    self.present(viewController, animated: true, completion: nil)
                }
            }
        }
    }
}
