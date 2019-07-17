//
//  TodayViewController.swift
//  Days Since Widget
//
//  Created by Michael Crump on 6/27/19.
//  Copyright © 2019 Michael Crump. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var lblStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
      UpdateMe()
    }
    
    func UpdateMe(){
        let defaults = UserDefaults.group
        defaults?.synchronize()
        
        let mc = defaults!.object(forKey: "DateDiff") ?? "0"
        lblStatus.text = mc as? String
        print(mc as? String ?? "0")
        
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        
       
        UpdateMe()
        completionHandler(NCUpdateResult.newData)
    }
  
    
}
extension UserDefaults {
    static let group = UserDefaults(suiteName: "group.net.michaelcrump.DaysSince")
}
//group.net.michaelcrump.DaysSince
