//
//  AppDelegate.swift
//  Todoey
//
//  Created by Eduardo Santiz on 4/29/19.
//  Copyright © 2019 EduardoSantiz. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        let config = Realm.Configuration(schemaVersion: 1, migrationBlock: { migration, oldSchemaVersion in
            if oldSchemaVersion < 1 {}
        })
        Realm.Configuration.defaultConfiguration = config
        
        do {
            _ = try Realm()
        } catch {
            print("Error initialising new Realm, \(error.localizedDescription)")
        }
        
        return true
    }

}

