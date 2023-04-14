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
    
    var tTitle = String()
    var cContext = String()
    var dDate = Double()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(tTitle)
        txtTitle.text = tTitle
        txtContext.text = cContext
    }
    
    
    @IBAction func btnSave(_ sender: UIButton) {
        
        
        if txtTitle != nil,txtContext != nil{
            let id = Auth.auth().currentUser?.uid
            
            let db = Firestore.firestore()
            guard let userId = Auth.auth().currentUser?.uid else {
                print("No authenticated user")
                return
            }
            let tasksCollection = db.collection(userId)
                .whereField("date", isEqualTo: dDate)

            
            // Retrieve the task document from Firestore
            tasksCollection.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    guard let snapshot = querySnapshot else {
                        print("No matching documents")
                        return
                    }
                    if snapshot.documents.count == 1 {
                        let document = snapshot.documents[0]
                        
                        // Update the isCompleted field of the task document
                        document.reference.updateData([
                            "title": self.txtTitle.text,"context": self.txtContext.text
                        ]) { err in
                            if let err = err {
                                print("Error updating document: \(err)")
                            } else {
                                print("Document successfully updated")
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    } else {
                        print("Multiple matching documents")
                    }
                }
            }
        }
        else{
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
            
            
        
       
        
    }
    
    @IBAction func btnCross(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
}
