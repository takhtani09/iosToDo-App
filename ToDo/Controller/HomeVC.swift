//
//  HomeVC.swift
//  ToDo
//
//  Created by IPS-108 on 12/04/23.
//

import UIKit
import Firebase

class HomeVC: UIViewController{
    
    var tblData = ["skdnckl", "lsdjckjb", "ksjdb", "ksdjb","skdnckl", "lsdjckjb", "ksjdb", "ksdjb","skdnckl", "lsdjckjb", "ksjdb", "ksdjb","skdnckl", "lsdjckjb", "ksjdb", "ksdjb","skdnckl", "lsdjckjb", "ksjdb", "ksdjb","skdnckl", "lsdjckjb", "ksjdb", "ksdjb","skdnckl", "lsdjckjb", "ksjdb", "ksdjb"]
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
    
    
    
    @IBAction func btnAdd(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
          let VC = storyboard.instantiateViewController(withIdentifier: "AddTaskVC") as! AddTaskVC
          VC.modalPresentationStyle = .overFullScreen  // for fullscreen
         //VC.sheetPresentationController?.detents = [.medium(),.large()] // for half and full screen
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
        db.collection(userId!).addSnapshotListener { (querySnapshot, error) in
            
            if let e = error{
                print("Error REtriving Data \(e)")
            }//data["context"] as? String
            else{
                self.task = []
                if let snapShotDocuments = querySnapshot?.documents{
                    for doc in snapShotDocuments{
                        let data = doc.data()
                        if let taskContext = data["context"] as? String, let tasktTitle = data["title"] as? String, let taskIsCompleted = data["isCompleted"] as? Bool, let taskSetter = data["sender"] as? String{
                            let newTask = Task(sender: taskSetter, title: tasktTitle, context: taskContext, isCompleted: taskIsCompleted)
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
        
        cell.txtNotes.text = tsk.context
        return cell
    }
}
