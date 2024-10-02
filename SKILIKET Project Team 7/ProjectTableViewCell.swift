//
//  ProjectTableViewCell.swift
//  SKILIKET Project Team 7
//
//  Created by Fernando Chiñas on 29/09/24.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var projectTitle: UILabel!
    
    @IBOutlet weak var projectImage: UIImageView!
    
    @IBOutlet weak var projectDescription: UILabel!
    
    @IBOutlet weak var projectDate: UILabel!
    
    @IBOutlet weak var userProjectImage: UIImageView!
    
    @IBOutlet weak var projectUser: UILabel!
    
    @IBOutlet weak var projectParticipants: UILabel!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
