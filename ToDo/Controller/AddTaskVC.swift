//
//  AddTaskVC.swift
//  ToDo
//
//  Created by IPS-108 on 13/04/23.
//

import UIKit
import Firebase

class AddTaskVC: UIViewController {
    
    let db = Firestore.firestore()
    
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtContext: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func btnSave(_ sender: UIButton) {
        
        if let title = txtTitle.text, title.isEmpty {
            print("Please enter a title.")
        } else if let context = txtContext.text, context.isEmpty {
            print("Please enter some content.")
        } else {
            if let title = txtTitle.text, let context = txtContext.text, let sender = Auth.auth().currentUser?.email,let userId = Auth.auth().currentUser?.uid{
                
                db.collection(userId).addDocument(data: ["sender": sender, "title":
                                                            title,"date": Date().timeIntervalSince1970, "context":context,"isCompleted": false]) { (error) in
                    if let e = error{
                        print("Issue Saving data \(e)")
                    }
                    else{
                        print("Succesfully Saved")
                    }
                }
            }
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func btnCross(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
}
