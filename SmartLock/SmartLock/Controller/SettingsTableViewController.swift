//
//  SettingsTableViewController.swift
//  SmartLock
//
//  Created by Max Zorzetti on 28/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit

class SettingsTableViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    @IBAction func unwindToSettings(segue:UIStoryboardSegue) { }
}

extension SettingsTableViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}

extension SettingsTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Places"
        case 1:
            return "User"
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "selectedHomeCell")!
            cell.detailTextLabel?.text = Session.shared.selectedHome!.name
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "logoutCell")!

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 0
        }
    }
}
