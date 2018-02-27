//
//  DevicesViewController.swift
//  SmartLock
//
//  Created by Matheus Vaccaro on 26/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit

class DevicesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var members: [User]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.members = Session.shared.selectedHome!.members
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DevicesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return members.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "CONNECTED DEVICES"
        } else {
            return "INVITES"
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return "This is a sample description that sits below a group."
        } else {
            return "An invite will expire after 24 hours."
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "deviceTableViewCell", for: indexPath)
            cell.textLabel?.text = members[indexPath.row].nickname
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "guestDeviceTableViewCell", for: indexPath) as! GuestDeviceTableViewCell
            cell.configureWith(title: "Marco", startingTime: Date(), endingTime: Date().addingTimeInterval(7200))
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
