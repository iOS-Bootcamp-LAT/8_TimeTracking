//
//  SummaryViewController.swift
//  8_TimeTracking
//
//  Created by David Granado Jordan on 7/7/22.
//

import UIKit

class SummaryViewController: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var containerView: UIView!
    
    private lazy var summaryTodayVC: SummaryTodayViewController = {
        //let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
        let vc = SummaryTodayViewController()
        return vc
    }()
    
    private lazy var summaryAllVC: SummaryAllViewController = {
        //let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TasksListViewController") as! TasksListViewController
        let vc = SummaryAllViewController()
        return vc
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentedControl()
        segmentedOptinChanged(nil)

    }
    
    func setupSegmentedControl() {
        segmentedControl.removeAllSegments()
        
        //segmentedControl.insertSegment(with: UIImage(systemName: "square.and.arrow.up.fill"), at: 0, animated: true)
        //segmentedControl.insertSegment(with: UIImage(systemName: "square.and.arrow.up.fill"), at: 1, animated: true)
        //segmentedControl.insertSegment(withTitle: "One", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Today", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "All", at: 1, animated: true)
        
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(segmentedOptinChanged), for: .valueChanged)
    }
    
    // Settup Secgmente control
    private func addViewController(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)

        // Add Child View as Subview
        containerView.addSubview(viewController.view)

        // Configure Child View
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)

        // Remove Child View From Superview
        viewController.view.removeFromSuperview()

        // Notify Child View Controller
        viewController.removeFromParent()
    }

    @objc func segmentedOptinChanged(_ sender: UISegmentedControl?) {
        
        switch segmentedControl.selectedSegmentIndex {
            
            
        case 0:
            remove(asChildViewController: summaryAllVC)
            addViewController(asChildViewController: summaryTodayVC)
        case 1:
            remove(asChildViewController: summaryTodayVC)
            addViewController(asChildViewController: summaryAllVC)
        default:
            remove(asChildViewController: summaryAllVC)
            addViewController(asChildViewController: summaryTodayVC)
            
        }
        
    }
    
}
