//
//  TaskTableViewCell.swift
//  8_TimeTracking
//
//  Created by David Granado Jordan on 7/1/22.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var taskColorView: UIView!
    
    @IBOutlet weak var tasktitleLabel: UILabel!
    
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    
    
    @IBOutlet weak var taskCreatedAtLabel: UILabel!
    
    
    @IBOutlet weak var timePunchSwitch: UISwitch!
    
    @IBOutlet weak var totalElapsedTimeLabel: UILabel!
    
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    
    var task: Task!
    
    var timePunch: TimePunch?
    private var timeKeepingTimer: Timer?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func setupViewForTask() {
        guard task != nil else { return }
        
        taskColorView.backgroundColor = UIColor.hexStringToUIColor(hex: task.color ?? "")
        tasktitleLabel.text = task.title
        taskDescriptionLabel.text = task.taskDescription
        timePunchSwitch.onTintColor = UIColor.hexStringToUIColor(hex: task.color ?? "")
        
        taskCreatedAtLabel.text = task.createdAt.description
        
        let totalElapsedTime = task.timePunchesArray.reduce(0) { x, y in
            x + y.elapsedTime
        }
        
        
        totalElapsedTimeLabel.text = "Total: \(TimeHelper.convertSecondsToHoursFormat(seconds: Int(totalElapsedTime)))"
        
        
        if let lastTimePunch = task.timePunchesArray.last, lastTimePunch.end == nil {
            self.timePunch = lastTimePunch
            timePunchSwitch.isOn = true
            createTimeTrackingTimer()
        } else {
            timeKeepingTimer?.invalidate()
            timePunchSwitch.isOn = false
        }
        
        
    }
    
    func setupViewForTimePunchHistory() {
        guard task != nil else { return }
        
        taskColorView.backgroundColor =  UIColor.hexStringToUIColor(hex: task.color ?? "")
        timePunchSwitch.isHidden = true
        tasktitleLabel.text = task.title
        taskDescriptionLabel.text = task.taskDescription
        
        let totalElapsedTime = task.timePunchesArray.reduce(0) { x, y in
            x + y.elapsedTime
        }
        totalElapsedTimeLabel.text = "Total: \(TimeHelper.convertSecondsToHoursFormat(seconds: Int(totalElapsedTime)))"
        
        
        
        taskCreatedAtLabel.text = timePunch?.createdAt.description
        
        guard let timePunch = timePunch else { return }

        elapsedTimeLabel.text = TimeHelper.convertSecondsToHoursFormat(seconds: Int(timePunch.elapsedTime))
        
    }
    
    
    func createTimeTrackingTimer() {
        timeKeepingTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimeTrackingLabel), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimeTrackingLabel() {
        let seconds = Date() - (timePunch?.start ?? Date())
        elapsedTimeLabel.text = TimeHelper.convertSecondsToHoursFormat(seconds: Int(seconds))
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margins = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        contentView.frame = contentView.frame.inset(by: margins)
        
        
    }
    
    
    
    @IBAction func onSwitchChanged(_ sender: UISwitch) {
        let context = CoreDataManager.shared.getContext()
        if sender.isOn {
            timePunch = TimePunch(context: context)
            timePunch?.id = Int16.random(in: 0...10000)
            timePunch?.start = Date()
            timePunch?.createdAt  = Date()
            timePunch?.task = task
            timePunch?.elapsedTime = 0
            
            try? context.save()
            
            createTimeTrackingTimer()
            
        } else {
            timePunch?.end = Date()
            timePunch?.elapsedTime = Int64(  (timePunch?.end ?? Date())  - (timePunch?.start ?? Date())  )
            
            try? context.save()
            timeKeepingTimer?.invalidate()
            
        }
        
    }
    
    
    
}
