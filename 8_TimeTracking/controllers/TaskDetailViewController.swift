//
//  CreateOrUpdateTaskViewController.swift
//  8_TimeTracking
//
//  Created by David Granado Jordan on 7/1/22.
//

import UIKit

protocol TaskDetailViewControllerDelegate {
    func taskCreated(task: Task)
    func taskUpdated(task: Task)
}


class TaskDetailViewController: UIViewController {
    var createNewTast = false
    var task: Task?
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var desTextField: UITextField!
    @IBOutlet weak var setTaskColorButton: UIButton!
    @IBOutlet weak var saveChangesButton: UIButton!
    
    let context = CoreDataManager.shared.getContext()
    var delegate: TaskDetailViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle()
        loadDataIfNeeded()
        
    }
    
    func setTitle() {
        if createNewTast {
            title = "Create Task"
            saveChangesButton.setTitle("Save Task", for: .normal)
        } else {
            title = task?.title ?? ""
            saveChangesButton.setTitle("Update Task", for: .normal)
        }
    }
    
    func loadDataIfNeeded() {
        if !createNewTast, let task = self.task {
            titleTextField.text = task.title
            desTextField.text = task.taskDescription
            setTaskColorButton.backgroundColor = UIColor.hexStringToUIColor(hex: task.color ?? "#E040FB")
        }
    }

    @IBAction func showColorPallete(_ sender: Any) {
        let picker = UIColorPickerViewController()
        picker.selectedColor = UIColor.hexStringToUIColor(hex: task?.color ?? "#E040FB")
        
        picker.delegate = self
        
        
        self.present(picker, animated: true, completion: nil)
        
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func saveOrUpdateTask(_ sender: Any) {
        guard let taskTitle = titleTextField.text, !taskTitle.isEmpty else { return }

        if createNewTast {
            task = Task(context: CoreDataManager.shared.getContext())
            task?.id = Int16.random(in: 0..<10000)
        }
        
        guard let task = task else { return }
        
        
        task.title = taskTitle
        task.taskDescription = desTextField.text
        task.createdAt = Date()
        task.updatedAt = Date()
        task.color = setTaskColorButton.backgroundColor?.toHexString()
        
        if createNewTast {
            self.showToast(message: "Created", seconds: 1)
            delegate?.taskCreated(task: task)
        } else {
            self.showToast(message: "Updated", seconds: 1)
            delegate?.taskUpdated(task: task)
        }
        try? context.save()
    }
    
}

extension TaskDetailViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {

        setTaskColorButton.backgroundColor = viewController.selectedColor

    }
    
    
}
