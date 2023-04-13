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
    
    @IBOutlet weak var tblView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblView.delegate = self
        tblView.dataSource = self
        
        navigationItem.hidesBackButton = true
    }
    
    @IBAction func logOut(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            navigationController?.popViewController(animated: true)
        }
        catch let logOutError as NSError{
            print("Error loging Out: %@", logOutError)
        }
        
    }
    
}


extension HomeVC :  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tblData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! TBVCell
        
        cell.txtNotes.text = tblData[indexPath.row]
        return cell
    }
}
