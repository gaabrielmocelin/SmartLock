//
//  EntranceHistoryViewController.swift
//  SmartLock
//
//  Created by Matheus Vaccaro on 23/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit

class EntranceHistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var entranceHistory: [EntranceItem]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.entranceHistory = Session.shared.selectedHome!.lock.entranceHistory
        self.tableView.reloadData()
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

extension EntranceHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.entranceHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntranceHistoryTableViewCell", for: indexPath) as! EntranceHistoryTableViewCell
        cell.configureWith(entranceItem: entranceHistory[indexPath.row])
        return cell
    }
}
