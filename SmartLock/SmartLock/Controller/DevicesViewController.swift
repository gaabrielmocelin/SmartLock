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
    private var guests: [Guest]!
    
    private var selectectedInviteType: InviteType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.members = Session.shared.selectedHome!.members
        self.guests = Session.shared.selectedHome!.guests
        let home = Session.shared.selectedHome!.name
        self.navigationItem.title = "\(home)'s Devices"
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let identifier = segue.identifier, let inviteType = selectectedInviteType {
            if identifier == "goToNewInvite" {
                let destination = segue.destination as! InviteViewController
                destination.newDeviceType = inviteType
            }
        }
    }
    
    @IBAction func unwindToDevicesViewController(segue: UIStoryboardSegue) {
        self.members = Session.shared.selectedHome!.members
        self.guests = Session.shared.selectedHome!.guests
        tableView.reloadData()
    }
}

extension DevicesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // + 1 represents the New Invite button
        if section == 0 {
            return members.count + 1
        } else {
            return guests.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "MEMBER DEVICES"
        } else {
            return "TEMPORARY DEVICES"
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 1 {
            return "An invite will expire after 24 hours if a timeframe is not set."
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == members.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "newInviteTableViewCell", for: indexPath) as! NewInviteTableViewCell
                cell.configureWith(title: "New Member")
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "deviceTableViewCell", for: indexPath)
            cell.textLabel?.text = members[indexPath.row].nickname
            return cell
        } else {
            if indexPath.row == guests.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "newInviteTableViewCell", for: indexPath) as! NewInviteTableViewCell
                cell.configureWith(title: "New Invite")
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "guestDeviceTableViewCell", for: indexPath) as! GuestDeviceTableViewCell
                let guest = guests[indexPath.row]
                cell.configureWith(title: guest.name, startingTime: guest.startingDate, endingTime: guest.endingDate)
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == members.count {
            selectectedInviteType = .newMember
            performSegue(withIdentifier: "goToNewInvite", sender: self)
        } else if indexPath.section == 1 && indexPath.row == guests.count {
            selectectedInviteType = .newGuest
            performSegue(withIdentifier: "goToNewInvite", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
