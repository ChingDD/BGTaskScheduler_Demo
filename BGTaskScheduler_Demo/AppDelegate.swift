//
//  AppDelegate.swift
//  BGTaskScheduler_Demo
//
//  Created by 林仲景 on 2024/7/21.
//

import UIKit
import BackgroundTasks

let taskID = (Bundle.main.infoDictionary?["BGTaskSchedulerPermittedIdentifiers"] as? [String])?.first

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

//    let id = (Bundle.main.object(forInfoDictionaryKey: "Permitted background task scheduler identifiers") as? [String])?.first
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // regist handler for task
        BGTaskScheduler.shared.register(forTaskWithIdentifier: taskID ?? "", using: nil) { task in
            guard let task  = task as? BGAppRefreshTask else { return }
            self.handleTask(task: task) {
                self.schedual()
            }
            print("Regist Success")
        }

        // current Number
        let number = UserDefaults.standard.integer(forKey: "bgNumber")
        print("number:\(number)")

        // Schedual Task
        schedual()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    // MARK: Custom Function
    func handleTask(task: BGAppRefreshTask, completion: @escaping () -> Void) {
        // count
        let count = UserDefaults.standard.integer(forKey: "bgNumber")
        UserDefaults.standard.setValue(count+1, forKey: "bgNumber")
        // date
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let dateStr = formatter.string(from: date)
        var dateStrArray = UserDefaults.standard.stringArray(forKey: "dateStr") ?? []
        dateStrArray.append(dateStr)
        UserDefaults.standard.setValue(dateStrArray, forKey: "dateStr")
        // task complete
        task.setTaskCompleted(success: true)
        completion()
    }
    
    fileprivate func schedual() {
        // test function: e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"demo.BGTaskScheduler-Demo-backgroundTest"]
//        BGTaskScheduler.shared.cancelAllTaskRequests()
        print("進入schedual")
        BGTaskScheduler.shared.getPendingTaskRequests { requests in
            print("pending requests counts: \(requests.count)")
            if requests.isEmpty {
                do {
                    let request = BGAppRefreshTaskRequest(identifier: taskID ?? "")
        //            request.earliestBeginDate = Date().addingTimeInterval(86400*3)
                    try BGTaskScheduler.shared.submit(request)
                    print("Submit Success")
                } catch {
                    print("Submit Error")
                }
            }
        }
    }
}

