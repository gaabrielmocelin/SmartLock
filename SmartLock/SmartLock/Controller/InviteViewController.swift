//
//  InviteViewController.swift
//  SmartLock
//
//  Created by Matheus Vaccaro on 28/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit
import Eureka

class InviteViewController: FormViewController {
    
    var newDeviceType: InviteType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch newDeviceType {
        case .newMember:
            navigationItem.title = "New Member"
        case .newGuest:
            navigationItem.title = "New Invite"
        default:
            navigationItem.title = "New Member"
        }
    
        if newDeviceType == .newMember {
            form +++ Section()
                <<< TextRow(){ row in
                    row.title = "Name"
                    row.tag = "Name"
                    row.placeholder = "Enter text here"
                }
                <<< PhoneRow(){
                    $0.title = "Phone"
                    $0.tag = "Phone"
                    $0.placeholder = "And phone number here"
            }
        } else {
        form +++ Section()
            <<< TextRow(){ row in
                row.title = "Name"
                row.tag = "Name"
                row.placeholder = "Enter text here"
            }
            <<< PhoneRow(){
                $0.title = "Phone"
                $0.tag = "Phone"
                $0.placeholder = "And phone number here"
            }
            <<< DateTimeInlineRow(){
                $0.title = "Starting Date"
                $0.tag = "StartingDate"
                $0.value = Date()
            }
            <<< DateTimeInlineRow(){
                $0.title = "Ending Date"
                $0.tag = "EndingDate"
                $0.value = Date().addingTimeInterval(86400)
            }
        navigationOptions = RowNavigationOptions.Disabled
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didPressDone(_ sender: Any) {
        switch newDeviceType {
        case .newMember:
            let nameRow: TextRow! = form.rowBy(tag: "Name")
            let name = nameRow.value ?? ""
            let phoneRow: PhoneRow! = form.rowBy(tag: "Phone")
            let phone = phoneRow.value ?? ""
            
            let member = User(nickname: name, phone: phone)
            
            Session.shared.selectedHome?.members.append(member)
            
            performSegue(withIdentifier: "unwindToDevices", sender: self)
        case .newGuest:
            let nameRow: TextRow! = form.rowBy(tag: "Name")
            let name = nameRow.value ?? ""
            let phoneRow: PhoneRow! = form.rowBy(tag: "Phone")
            let phone = phoneRow.value ?? ""
            let startingDateRow: DateTimeInlineRow! = form.rowBy(tag: "StartingDate")
            let startingDate = startingDateRow.value ?? Date()
            let endingDateRow: DateTimeInlineRow! = form.rowBy(tag: "EndingDate")
            let endingDate = endingDateRow.value ?? Date()
            
            let guest = Guest(name: name, phone: phone, startingDate: startingDate, endingDate: endingDate)
            
            Session.shared.selectedHome?.guests.append(guest)
            
            performSegue(withIdentifier: "unwindToDevices", sender: self)
        default:
            return
        }
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

enum InviteType {
    case newMember
    case newGuest
}
