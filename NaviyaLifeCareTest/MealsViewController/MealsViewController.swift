//
//  MealsViewController.swift
//  NaviyaLifeCareTest
//
//  Created by Aman gupta on 28/08/18.
//  Copyright © 2018 Aman Gupta. All rights reserved.
//

import UIKit
import UserNotifications

class MealsViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    var dietModel: DietData?
    var weekDataArray = [[MealDetail]]()
    var sectionHeaderTitleArray = [String]()
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initNotificationSetupCheck()
        registerCell()
        getJsonData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // Register User notification
    func initNotificationSetupCheck() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { (success, error) in
            if success {
                print("success")
            } else {
                print("error")
            }
        }
    }
    
    // MARK: - SetUp Controller
    func registerCell() {
        self.tableView.register(MealsDetailsTableViewCell.nib, forCellReuseIdentifier: MealsDetailsTableViewCell.reuseIdentifier)
    }
    
}

// MARK: - Table view data source
extension MealsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weekDataArray[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.weekDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MealsDetailsTableViewCell.reuseIdentifier, for: indexPath) as! MealsDetailsTableViewCell
        cell.configureMealDetailCell(withModel: self.weekDataArray[indexPath.section][indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionHeaderTitleArray[section]
    }
    
}

// MARK: - Table view cell delegate
extension MealsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}

// MARK: - Get json data
extension MealsViewController {
    func getJsonData() {
        DispatchQueue.global().async {
            if let path = Bundle.main.path(forResource: "Meals", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                    let decoder = JSONDecoder()
                    do {
                        let dietData = try decoder.decode(DietData.self, from: data)
                        self.dietModel = dietData
                        self.sectionHeaderTitleArray.removeAll()
                        self.weekDataArray.removeAll()
                        if let weekData = dietData.weekDietData {
                            if let sunday = weekData.sunday {
                                self.weekDataArray.append(sunday)
                                self.sectionHeaderTitleArray.append(Days.sunday.rawValue)
                                self.triggerMultipleNotification(arrMeal: sunday, weekDay: WeekDay.sunday.rawValue)
                            }
                            if let monday = weekData.monday {
                                self.weekDataArray.append(monday)
                                self.sectionHeaderTitleArray.append(Days.monday.rawValue)
                                self.triggerMultipleNotification(arrMeal: monday, weekDay: WeekDay.monday.rawValue)
                            }
                            if let tuesday = weekData.tuesday {
                                self.weekDataArray.append(tuesday)
                                self.sectionHeaderTitleArray.append(Days.tuesday.rawValue)
                                self.triggerMultipleNotification(arrMeal: tuesday, weekDay: WeekDay.tuesday.rawValue)
                            }
                            if let wednesday = weekData.wednesday {
                                self.weekDataArray.append(wednesday)
                                self.sectionHeaderTitleArray.append(Days.wednesday.rawValue)
                                self.triggerMultipleNotification(arrMeal: wednesday, weekDay: WeekDay.wednesday.rawValue)
                            }
                            if let thursday = weekData.thursday {
                                self.weekDataArray.append(thursday)
                                self.sectionHeaderTitleArray.append(Days.thursday.rawValue)
                                self.triggerMultipleNotification(arrMeal: thursday, weekDay: WeekDay.thursday.rawValue)
                            }
                            if let friday = weekData.friday {
                                self.weekDataArray.append(friday)
                                self.sectionHeaderTitleArray.append(Days.friday.rawValue)
                                self.triggerMultipleNotification(arrMeal: friday, weekDay: WeekDay.friday.rawValue)
                            }
                            if let saturday = weekData.saturday {
                                self.weekDataArray.append(saturday)
                                self.sectionHeaderTitleArray.append(Days.saturday.rawValue)
                                self.triggerMultipleNotification(arrMeal: saturday, weekDay: WeekDay.saturday.rawValue)
                            }
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } catch {
                        print("Json decoder error")
                    }
                } catch {
                    print("json error")
                }
            }
        }
    }
}

// MARK: - Helper methdos
extension MealsViewController {
    // Get time in seconds from current date Before 5 min
    func getTimeFromCurrentDate(time: String, day: Int) -> TimeInterval? {
        let currentDate = Date()
        let weekday = Calendar.current.component(.weekday, from: Date())
        
        let arrTime = time.components(separatedBy: ":")
        var hour: Int = 0
        var min: Int = 0
        var sec: Int = 0
        
        for (index, item) in arrTime.enumerated() {
            if index == 0 {
                hour = Int(item) ?? 0
            }
            if index == 1 {
                min = Int(item) ?? 0
            }
            if index == 2 {
                sec = Int(item) ?? 0
            }
        }
        let timeIntervalInWeek: Double = 7.0 * 24.0 * Double(kSecondInHour)
        
        let calender = Calendar.current
        var dateComponent = calender.dateComponents([.hour, .minute, .day, .second,.weekday, .month, .year], from: currentDate)
        
        dateComponent.hour = hour
        dateComponent.minute = min
        dateComponent.second = sec
        dateComponent.weekday = weekday
        
        if let timeInterval = calender.date(from: dateComponent)?.timeIntervalSinceNow {
            var tempTimeInterval = timeInterval - (5.0 * Double(kSecondInMin))
            if tempTimeInterval < 0 {
                tempTimeInterval = timeIntervalInWeek + timeInterval
                return tempTimeInterval
            } else {
                return tempTimeInterval
            }
        }
        return nil
    }
    
    // Trigger notification
    func notification(timeInterval: Double, body: String) {
        let notification = UNMutableNotificationContent()
        notification.title = "Food"
        notification.body = body
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: "\(Date().timeIntervalSinceNow)", content: notification, trigger: notificationTrigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    // Trigger Multipule notification
    func triggerMultipleNotification(arrMeal: [MealDetail], weekDay: Int) {
        for item in arrMeal {
            if let time = item.mealTime {
                let timeInterval = self.getTimeFromCurrentDate(time: time , day: weekDay)
                if let tempTimeInterval = timeInterval {
                    self.notification(timeInterval: tempTimeInterval, body: item.food ?? "No food name")
                }
            }
        }
    }
    
}
