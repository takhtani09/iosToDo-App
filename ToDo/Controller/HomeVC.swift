//
//  HomeVC.swift
//  ToDo
//
//  Created by IPS-108 on 12/04/23.
//

import UIKit
import Firebase

class HomeVC: UIViewController, TBVCellDelegate{
    
    
    
    let db = Firestore.firestore()
    
    var task : [Task] = []
    
    @IBOutlet weak var tblView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblView.delegate = self
        tblView.dataSource = self
        
        navigationItem.hidesBackButton = true
        loadTask()
    }
    
    func dltTask(for cell: TBVCell) {
        guard let indexPath = tblView.indexPath(for: cell) else { return }
        let task = self.task[indexPath.row]
        
        let id = Auth.auth().currentUser?.uid

        let db = Firestore.firestore()
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No authenticated user")
            return
        }
        let tasksCollection = db.collection(userId)
            .whereField("date", isEqualTo: task.date)

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
                    
                    // Delete the task document from Firestore
                    document.reference.delete() { err in
                        if let err = err {
                            print("Error deleting document: \(err)")
                        } else {
                            print("Document successfully deleted")
                            self.tblView.reloadData()
                        }
                    }
                }
            }
        }

        
    }
    
    func editTask(for cell: TBVCell) {
        
        guard let indexPath = tblView.indexPath(for: cell) else { return }
        
        
        let task = self.task[indexPath.row]
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "AddTaskVC") as! AddTaskVC
        
        

        
        VC.tTitle = task.title
        VC.cContext = task.context
        VC.dDate = task.date
        
        VC.modalPresentationStyle = .overFullScreen
        VC.sheetPresentationController?.prefersGrabberVisible = true
        self.present(VC, animated: true)
    }
    
    
    
    @IBAction func btnAdd(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "AddTaskVC") as! AddTaskVC
        
        VC.modalPresentationStyle = .overFullScreen
        VC.sheetPresentationController?.prefersGrabberVisible = true
        self.present(VC, animated: true)
    }
    
    @IBAction func logOut(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        catch let logOutError as NSError{
            print("Error loging Out: %@", logOutError)
        }
        
    }
    
    func loadTask(){
        
        let userId = Auth.auth().currentUser?.uid
        db.collection(userId!).order(by: "date").addSnapshotListener { (querySnapshot, error) in
            
            if let e = error{
                print("Error REtriving Data \(e)")
            }//data["context"] as? String
            else{
                self.task = []
                if let snapShotDocuments = querySnapshot?.documents{
                    for doc in snapShotDocuments{
                        let data = doc.data()
                        if let taskContext = data["context"] as? String, let tasktTitle = data["title"] as? String, let taskIsCompleted = data["isCompleted"] as? Bool, let taskSetter = data["sender"] as? String,let date = data["date"] as? Double{
                            let newTask = Task(sender: taskSetter, title: tasktTitle, context: taskContext, isCompleted: taskIsCompleted, date: date)
                            self.task.append(newTask)
                            
                            DispatchQueue.main.async {
                                self.tblView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
}


extension HomeVC :  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return task.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tsk = task[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! TBVCell
        
        cell.delegate = self
        
        cell.txtTitle.text = tsk.title
        cell.txtContext.text = tsk.context
        
        if tsk.isCompleted{
            cell.btnStatus.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
            cell.btnStatus.tintColor = UIColor.green
        }
        else{
            cell.btnStatus.setImage(UIImage(systemName: "hand.thumbsdown.fill"), for: .normal)
            cell.btnStatus.tintColor = UIColor.red
        }
        
        return cell
    }
}
