//
//  EntranceHistoryTableViewCell.swift
//  SmartLock
//
//  Created by Matheus Vaccaro on 23/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit

class EntranceHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lockActionLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureWith(entranceItem: EntranceItem) {
        self.nameLabel.text = entranceItem.name
        self.lockActionLabel.text = entranceItem.lockStatus.formattedOutput
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .medium
        self.timestampLabel.text = dateFormatter.string(from: entranceItem.timeStamp)
    }
}
