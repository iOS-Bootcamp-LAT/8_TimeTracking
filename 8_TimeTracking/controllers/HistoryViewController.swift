//
//  HistoryViewController.swift
//  8_TimeTracking
//
//  Created by David Granado Jordan on 6/30/22.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    var timePunches = [TimePunch]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        //loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        
    }
    
    
    func loadData() {
        
        
        let fetchRequest = NSFetchRequest<TimePunch>(entityName: "TimePunch")
        let sort = NSSortDescriptor(key: #keyPath(TimePunch.createdAt), ascending: false)
        
        fetchRequest.sortDescriptors = [sort]
        
        let context = CoreDataManager.shared.getContext()
        
        do {
            timePunches = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Error: ", error)
        }
        
        
        
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskTableViewCell")
    }
    
}

extension HistoryViewController:  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        timePunches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        
        let timePunch = timePunches[indexPath.row]
        
        cell.timePunch = timePunch
        cell.task = timePunch.task
        cell.setupViewForTimePunchHistory()
        
        return cell
        
    }
    
    
}
