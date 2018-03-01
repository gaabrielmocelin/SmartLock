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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapRecognizer)
        
        form +++ Section()
            <<< TextRow(){ row in
                row.title = "Name"
                row.tag = "Name"
                row.placeholder = "Enter text here"
            }
            <<< PhoneRow(){
                $0.title = "Phone"
                $0.tag = "Phone"
                $0.placeholder = "And numbers here"
            }
            <<< DateTimeInlineRow(){
                $0.title = "Starting Date"
                $0.tag = "StartingDate"
                $0.value = Date()
            }
            <<< DateTimeInlineRow(){
                $0.title = "Ending Date"
                $0.tag = "Ending Date"
                $0.value = Date().addingTimeInterval(86400)
            }
        navigationOptions = RowNavigationOptions.Disabled
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
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
