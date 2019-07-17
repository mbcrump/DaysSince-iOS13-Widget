//
//  ViewController.swift
//  DaysSince
//
//  Created by Michael Crump on 6/23/19.
//  Copyright © 2019 Michael Crump. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
    
    @IBOutlet weak var dp: UIDatePicker!
    
    @IBAction func saveDate(_ sender: Any) {
        print("Saved Button Pressed - This is the saved date : \(dp.date))")
        SaveDate()
    }

    @IBAction func dp(_ sender: Any) {
        print("This is the DP Value being changed : \(dp.date))")
        SaveDate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
        if let name = UserDefaults.standard.object(forKey: "setDate") as! Date? {
            dp.setDate(name, animated: true)
            print(name)
        } else {
            let currentDate = Date()
            dp.setDate(currentDate, animated: true)
            print(currentDate)
        }
        registerBackgroundTask()
        doSomeDownload()

    }
    
    func doSomeDownload() {
        //call endBackgroundTask() on completion..
        switch UIApplication.shared.applicationState {
        case .active:
            print("App is active.")
        case .background:
            scheduleNotification()
            print("App is in background.")
            print("Background time remaining = \(UIApplication.shared.backgroundTimeRemaining) seconds")
        case .inactive:
            break
        @unknown default:
            break
        }
    }
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        assert(backgroundTask != UIBackgroundTaskIdentifier.invalid)
    }
    
    func endBackgroundTask() {
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskIdentifier.invalid
    }
    
    func SaveDate() {
        UserDefaults.standard.set(dp.date, forKey: "setDate")
        scheduleNotification()
    }
    
    func scheduleNotification() {

        let content = UNMutableNotificationContent()
        
        var fromDate = UserDefaults.standard.object(forKey: "setDate") as! Date?
        
        if (fromDate == nil) {
            fromDate = Date()
        }
       
        
        
        let currentDate = Date()
        
         print("Tonight at midnight is " + currentDate.midnight.localString())
       // let diffInDays = Calendar.current.dateComponents([.day], from: fromDate!, to: currentDate).day
       // let diff = tomorrow.interval(ofComponent: .day, fromDate: yesterday)
        
        let components = Set<Calendar.Component>([.day])
        let differenceOfDate = Calendar.current.dateComponents(components, from: fromDate!.midnight, to: currentDate.midnight).day
//        print("-------------------")
//        print(fromDate!.midnight)
//        print(currentDate.midnight)
//        print("-------------------")
        content.title = "DaysSince"
        content.body = "It has been \(differenceOfDate!) since"
        
        UIApplication.shared.applicationIconBadgeNumber = differenceOfDate!
        
        let defaults = UserDefaults(suiteName: "group.net.michaelcrump.DaysSince") // this is the name of the group we added in "App Groups"
        defaults?.set(String(differenceOfDate!), forKey: "DateDiff")
        defaults?.synchronize()
        print(differenceOfDate!)

        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "SimplifiedIOSNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
 
 
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound]) //calls the completionHandler indicating that both the alert and the sound is to be presented to the user
    }
}


extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
        func localString(dateStyle: DateFormatter.Style = .medium,
                         timeStyle: DateFormatter.Style = .medium) -> String {
            return DateFormatter.localizedString(
                from: self,
                dateStyle: dateStyle,
                timeStyle: timeStyle)
        }
        
        var midnight:Date{
            let cal = Calendar(identifier: .gregorian)
            return cal.startOfDay(for: self)
        }
    
}

