//
//  RegisterVC.swift
//  ToDo
//
//  Created by IPS-108 on 12/04/23.
//

import UIKit
import Firebase

class RegisterVC: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnRegister(_ sender: UIButton) {
        // Check that all required fields are filled
        guard let email = txtEmail.text,
              let password = txtPassword.text,
              let confirmPassword = txtConfirmPassword.text,
              !email.isEmpty,
              !password.isEmpty,
              !confirmPassword.isEmpty else {
                  // Show an error message if any fields are missing
                  showAlert(message: "Please fill in all required fields.")
                  return
              }
        
        // Check that password and confirm password match
        guard password == confirmPassword else {
            // Show an error message if passwords don't match
            showAlert(message: "Password and Confirm Password do not match.")
            return
        }
        
        // Register user with Firebase Authentication
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard let user = authResult?.user, error == nil else {
                // Show an error message if there was a problem registering the user
                self.showAlert(message: error?.localizedDescription ?? "Unknown error")
                return
            }
            
            // User registration successful
            print("User registered successfully: \(user.uid)")
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}
