//
//  SummaryTodayViewController.swift
//  8_TimeTracking
//
//  Created by David Granado Jordan on 7/11/22.
//

import UIKit
import CoreData

class SummaryTodayViewController: UIViewController {
    var timePunches = [TimePunch]()
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
         https://quickchart.io/chart?c={type:'pie',data:{labels:['January','February', 'March','April', 'May'], datasets:[ {data:[50,60,70,180,190], backgroundColor: [ 'rgb(255, 99, 132)', 'rgb(255, 159, 64)', 'rgb(255, 205, 86)', 'rgb(75, 192, 192)', 'rgb(54, 162, 235)', ]  }]}}
         
         */
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }

    func loadData() {
        let context = CoreDataManager.shared.getContext()
        
        let fetchRequest = NSFetchRequest<TimePunch>(entityName: "TimePunch")
        let sort = NSSortDescriptor(key: #keyPath(TimePunch.createdAt), ascending: false)
        
        fetchRequest.sortDescriptors = [sort]
        
        
        do {
            timePunches = try context.fetch(fetchRequest)
            loadImage()
        } catch {
            print("Error: ", error)
        }
    }
    
    func loadImage() {
        
        let todayTimepunches = timePunches.filter({
            Calendar.current.isDateInToday( $0.createdAt)
        })
        
        let todayTimePunchesGroupByTask = Dictionary(grouping: todayTimepunches, by: {   $0.task?.id ?? -1 })
        
        /**
                    [{1 }, {2 }, {1 }, {1 },]
         
                    [
                        "1": [{1 },{1 }, {1 }],
                        "2": [ {2 }]
                    ]
         */
        
        var todayLabels = ""
        var todayDataSets = ""
        var todayBackgroundColor = ""
        
        todayTimePunchesGroupByTask.forEach { (key, value) in
            // LABELS
            if !todayLabels.isEmpty {
                todayLabels.append(",")
            }
            todayLabels.append(" '\(value.first?.task?.title ?? "")'   ")
            
            // DATASETS
            if !todayDataSets.isEmpty {
                todayDataSets.append(",")
            }
            let totalElapsedTime = value.reduce(0.0) { lastResult, currentTimePunch in
                lastResult + Double(currentTimePunch.elapsedTime)
            }
            let totalInHours = ( totalElapsedTime / 60 ) / 60
            let totalHoursFormated = String(format: "%.3f", totalInHours)
                
            todayDataSets.append("  '\(totalHoursFormated)' ")
            
            //BACKGROUND
            if !todayBackgroundColor.isEmpty {
                todayBackgroundColor.append(",")
            }
            todayBackgroundColor.append("  '\(value.first?.task?.color ?? "#FF3784")' ")
            
        }


            
        
        todayLabels = "  [ \(todayLabels) ]"
        todayDataSets = " [ \(todayDataSets) ] "
        todayBackgroundColor = " [ \(todayBackgroundColor) ] "
        
        let todayURLStr =  "https://quickchart.io/chart?c={type:'pie',data:{labels:\(todayLabels), datasets:[{data:\(todayDataSets), 'backgroundColor': \(todayBackgroundColor)   }]}}"
        
        
        let todayURL = todayURLStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed).flatMap(URL.init)!
        
        
        if todayTimepunches.isEmpty {
            imageView.image = UIImage(named: "no_record")
        } else {
            imageView.load(url: todayURL)
        }
        
    }

}


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.image = UIImage(named: "no_record")
                    }
                }
            }
        }
    }
}
