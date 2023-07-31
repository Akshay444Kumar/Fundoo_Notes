//
//  SetReminderViewController.swift
//  CustomLogin
//
//  Created by YE002 on 18/07/23.
//

import UIKit

class SetReminderViewController: UIViewController {
    
    @IBOutlet var reminderTitle: UITextField!
    @IBOutlet var reminderMessage: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    var titleString: String?
    let notificationCenter = UNUserNotificationCenter.current()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reminderTitle.text = titleString ?? ""
    }
    
    
    @IBAction func scheduleReminderTapped(_ sender: UIButton) {
        
        notificationCenter.getNotificationSettings { settings in
            
            DispatchQueue.main.async {
                let title = self.reminderTitle.text!
                let message = self.reminderMessage.text!
                let date = self.datePicker.date
                
                if (settings.authorizationStatus == .authorized)
                {
                    let content = UNMutableNotificationContent()
                    content.title = title
                    content.body = message
                    
                    let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
                    
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    
                    self.notificationCenter.add(request) { error in
                        if error != nil
                        {
                            print("Error " + error.debugDescription)
                            return
                        }
                    }
                    let ac = UIAlertController(title: "Notification Scheduled", message: "At " + self.formattedDate(date: date), preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in }))
                    self.present(ac, animated: true)
                    
                }
                else
                {
                    let ac = UIAlertController(title: "Enable Notifications?", message: "To use this feature you must enable notifications in settings", preferredStyle: .alert)
                    let goToSettings = UIAlertAction(title: "Settings", style: .default) { _ in
                        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {return}
                        
                        if UIApplication.shared.canOpenURL(settingsURL)
                        {
                            UIApplication.shared.open(settingsURL) { _ in}
                        }
                    }
                    ac.addAction(goToSettings )
                    ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in }))
                    self.present(ac, animated: true)
                }
            }
        }
    }
    
    
    func formattedDate(date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y HH:mm"
        return formatter.string(from: date)
    }
}

