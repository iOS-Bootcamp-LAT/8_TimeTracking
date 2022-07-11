//
//  ViewController.swift
//  8_TimeTracking
//
//  Created by David Granado Jordan on 6/28/22.
//

import UIKit
import CoreData

class TasksListViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    var tasks = [Task]()
    
    @IBOutlet weak var floatingButton: FloatingButton!
    
    var lastContentOffset: CGFloat = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadData()
    }
    
    
    func loadData() {
        
        
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        let context = CoreDataManager.shared.getContext()
        
        do {
            let dbTasks = try context.fetch(fetchRequest)
            self.tasks = dbTasks
            tableView.reloadData()
        } catch {
            print(error)
        }
        
    }
    

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        // tableView.rowHeight = UITableView.automaticDimension
        // tableView.estimatedRowHeight = 500
        tableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskTableViewCell")
    }
    
    
    @IBAction func addTask(_ sender: Any) {
        let vc = TaskDetailViewController()
        vc.createNewTast = true
        vc.delegate = self
        show(vc, sender: nil)
        
        
 
        /*let vc = TaskDetailViewController()
        if let presentationController = vc.presentationController as? UISheetPresentationController {
            presentationController.detents = [.large()] /// change to [.medium(), .large()] for a half *and* full screen sheet
        }
        
        self.present(vc, animated: true)*/
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        /*print("Y: ", velocity.y)
        if velocity.y > 0 {
            
            self.floatingButton.hide()

        } else {

            self.floatingButton.show()

        }*/
    }
    
}



extension TasksListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    
    // this delegate is called when the scrollView (i.e your UITableView) will start scrolling
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let allelements = CGFloat( tasks.count + 1)
        let cellHeight = tableView.visibleCells.map({ $0.contentView.frame.height }).reduce(0, +) / CGFloat(tableView.visibleCells.count)
        let contentHeight = cellHeight * allelements
        
        if self.lastContentOffset < scrollView.contentOffset.y {
            self.floatingButton.hide()
        } else if self.lastContentOffset > scrollView.contentOffset.y, contentHeight > tableView.frame.height {
            self.floatingButton.show()
        } else {
            self.floatingButton.show()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as? TaskTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.task = tasks[indexPath.row]
        cell.setupViewForTask()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TaskDetailViewController()
        vc.createNewTast = false
        vc.delegate = self
        vc.task = tasks[indexPath.row]
        show(vc, sender: nil)
    }
    
    
}

extension TasksListViewController: TaskDetailViewControllerDelegate {
    func taskCreated(task: Task) {
        tasks.append(task)
        tableView.reloadData()
    }
    
    func taskUpdated(task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            let indexPath = IndexPath(row: index, section: 0)
            tableView.reloadRows(at: [ indexPath ], with: .automatic)
        }
        
    }
    
    
}
