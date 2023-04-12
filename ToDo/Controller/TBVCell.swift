//
//  TBVCell.swift
//  ToDo
//
//  Created by IPS-108 on 12/04/23.
//

import UIKit

class TBVCell: UITableViewCell {

    @IBOutlet weak var txtNotes: UILabel!
    @IBOutlet weak var btnStatus: UIButton!
    
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
        
        if taskStatus == false{
            btnStatus.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
            btnStatus.tintColor = UIColor.green
            taskStatus = true
        }
        else{
            btnStatus.setImage(UIImage(systemName: "hand.thumbsdown.fill"), for: .normal)
            btnStatus.tintColor = UIColor.red
            taskStatus = false
        }
        
    }
    
}
