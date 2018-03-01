//
//  DeviceTableViewCell.swift
//  SmartLock
//
//  Created by Matheus Vaccaro on 26/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit

class GuestDeviceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeFrameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWith(title: String, startingTime: Date, endingTime: Date) {
        self.titleLabel.text = title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let start = dateFormatter.string(from: startingTime)
        let end = dateFormatter.string(from: endingTime)
//        self.timeFrameLabel.text = "\(start) - \(end)"
        self.timeFrameLabel.text = "Valid until \(end)"
    }

}
