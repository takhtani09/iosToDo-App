//
//  TBVCell.swift
//  ToDo
//
//  Created by IPS-108 on 12/04/23.
//

import UIKit
import Firebase
import SwiftUI

protocol TBVCellDelegate: AnyObject {
    func editTask(for cell: TBVCell)
}

class TBVCell: UITableViewCell {

    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var txtContext: UILabel!
    @IBOutlet weak var btnStatus: UIButton!
    
    weak var delegate: TBVCellDelegate?
    
    var taskStatus = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnStatus(_ sender: UIButton) {
        
        if taskStatus == false {
            btnStatus.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
            btnStatus.tintColor = UIColor.green
            taskStatus = true
        } else {
            btnStatus.setImage(UIImage(systemName: "hand.thumbsdown.fill"), for: .normal)
            btnStatus.tintColor = UIColor.red
            taskStatus = false
        }
        
        // Get a reference to the collection of tasks for the current user in Firestore
        let db = Firestore.firestore()
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No authenticated user")
            return
        }
        let tasksCollection = db.collection(userId)
            .whereField("title", isEqualTo: txtTitle.text!)
            .whereField("context", isEqualTo: txtContext.text!)

        
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
                        "isCompleted": self.taskStatus
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                    }
                } else {
                    print("Multiple matching documents")
                }
            }
        }
    }


    
    @IBAction func btnEdit(_ sender: UIButton) {
        delegate?.editTask(for: self)
    }
    
    @IBAction func btnDelete(_ sender: UIButton) {
    }
    
}
