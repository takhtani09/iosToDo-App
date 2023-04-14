//
//  LoginVC.swift
//  ToDo
//
//  Created by IPS-108 on 12/04/23.
//
import UIKit
import Firebase

class LoginVC: UIViewController {

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        // Check that all required fields are filled
        guard let email = txtUsername.text,
              let password = txtPassword.text,
              !email.isEmpty,
              !password.isEmpty else {
            // Show an error message if any fields are missing
            showAlert(message: "Please fill in all required fields.")
            return
        }
        
        // Login user with Firebase Authentication
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard let user = authResult?.user, error == nil else {
                // Show an error message if there was a problem logging in the user
                self.showAlert(message: error?.localizedDescription ?? "Unknown error")
                return
            }
            
            // User login successful
            print("User logged in successfully: \(user.uid)")
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @IBAction func goToREgister(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        self.navigationController?.popViewController(animated: true)
    }
    
}
