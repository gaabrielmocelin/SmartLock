//
//  HomeTableViewCell.swift
//  SmartLock
//
//  Created by Matheus Vaccaro on 22/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureWith(name:String) {
        self.nameLabel.text = name
    }
}
