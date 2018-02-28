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
    private var lock: Lock!
    private var entranceHistory: [EntranceItem]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // New history entries at the beginning
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.lock = Session.shared.selectedHome!.lock
        self.navigationItem.title = "\(lock.name)'s History"
        breakNavigationItemTitle()
        
        entranceHistory = lock.entranceHistory
        
        let indexPath = IndexPath(row: 0, section: 0)
        lock.subscribe(observer: self) { [unowned self] oldValue, newValue in
            self.entranceHistory = self.lock.entranceHistory.reversed()
            self.tableView.reloadData()
            if self.lock.entranceHistory.count != 0 {
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        entranceHistory = lock.entranceHistory.reversed()
        tableView.reloadData()
        if lock.entranceHistory.count != 0 {
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
//    // New history entries at the end
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        self.lock = Session.shared.selectedHome!.lock
//        self.navigationItem.title = "\(lock.id)'s History"
//        entranceHistory = lock.entranceHistory
//        
//        lock.subscribe(observer: self) { [weak self] oldValue, newValue in
//            self?.entranceHistory = self?.lock.entranceHistory
//            self?.tableView.reloadData()
//            if self?.entranceHistory.count != 0 {
//                let indexPath = IndexPath(row: self!.lock.entranceHistory.count-1, section: 0)
//                self?.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
//            }
//        }
//        entranceHistory = lock.entranceHistory.reversed()
//        tableView.reloadData()
//        if entranceHistory.count != 0 {
//            let indexPath = IndexPath(row: self.lock.entranceHistory.count-1, section: 0)
//            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
//        }
//    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        lock.unsubscribe(observer: self)
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
        return entranceHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntranceHistoryTableViewCell", for: indexPath) as! EntranceHistoryTableViewCell
        cell.configureWith(entranceItem: entranceHistory[indexPath.row])
        return cell
    }
}
