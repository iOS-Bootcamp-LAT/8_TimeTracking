//
//  SummaryAllViewController.swift
//  8_TimeTracking
//
//  Created by David Granado Jordan on 7/11/22.
//

import UIKit
import CoreData

class SummaryAllViewController: UIViewController {

    var timePunches = [TimePunch]()
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

        let allTimePunchesGroupByTask = Dictionary(grouping: timePunches, by: {   $0.task?.id ?? -1 })
        
        /**
                    [{1 }, {2 }, {1 }, {1 },]
         
                    [
                        "1": [{1 },{1 }, {1 }],
                        "2": [ {2 }]
                    ]
         */
        
        var allLabels = ""
        var allDataSets = ""
        var allBackgroundColor = ""
        
        allTimePunchesGroupByTask.forEach { (key, value) in
            // LABELS
            if !allLabels.isEmpty {
                allLabels.append(",")
            }
            allLabels.append(" '\(value.first?.task?.title ?? "")'   ")
            
            // DATASETS
            if !allDataSets.isEmpty {
                allDataSets.append(",")
            }
            let totalElapsedTime = value.reduce(0.0) { lastResult, currentTimePunch in
                lastResult + Double(currentTimePunch.elapsedTime)
            }
            let totalInHours = ( totalElapsedTime / 60 ) / 60
            let totalHoursFormated = String(format: "%.3f", totalInHours)
                
            allDataSets.append("  '\(totalHoursFormated)' ")
            
            //BACKGROUND
            if !allBackgroundColor.isEmpty {
                allBackgroundColor.append(",")
            }
            allBackgroundColor.append("  '\(value.first?.task?.color ?? "#FF3784")' ")
            
        }


            
        
        allLabels = "  [ \(allLabels) ]"
        allDataSets = " [ \(allDataSets) ] "
        allBackgroundColor = " [ \(allBackgroundColor) ] "
        
        let todayURLStr =  "https://quickchart.io/chart?c={type:'pie',data:{labels:\(allLabels), datasets:[{data:\(allDataSets), 'backgroundColor': \(allBackgroundColor)   }]}}"
        
        
        let todayURL = todayURLStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed).flatMap(URL.init)!
        
        
        if timePunches.isEmpty {
            imageView.image = UIImage(named: "no_record")
        } else {
            imageView.load(url: todayURL)
        }
        
    }


}
