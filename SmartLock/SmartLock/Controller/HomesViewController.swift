//
//  HomesViewController.swift
//  SmartLock
//
//  Created by Matheus Vaccaro on 22/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit

class HomesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HomesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Session.shared.user!.homes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        let home = Session.shared.user!.homes[indexPath.row]
        cell.configureWith(name: home.name)
        
        cell.accessoryType = home === Session.shared.selectedHome! ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Removes checkmark from previously selected home
        let oldSelectedHome = Session.shared.selectedHome
        let oldSelectedHomeIndex = Session.shared.user!.homes.index{ $0 === oldSelectedHome }!
        tableView.cellForRow(at: IndexPath(row: oldSelectedHomeIndex, section: 0))!.accessoryType = .none
        
        // Adds checkmark to new selected home
        let newHomeCell = tableView.cellForRow(at: indexPath)!
        newHomeCell.accessoryType = .checkmark
        
        let home = Session.shared.user!.homes[indexPath.row]
        Session.shared.selectedHome = home
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
