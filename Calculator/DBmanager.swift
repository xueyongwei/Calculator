//
//  DBmanager.swift
//  Calculator
//
//  Created by 薛永伟 on 2017/10/29.
//  Copyright © 2017年 xhGroup. All rights reserved.
//

import UIKit

class DBmanager: NSObject {
    static let shared = DBmanager()
    
    lazy var queryContext: OHMySQLQueryContext = OHMySQLQueryContext()
    
    private override init(){}
    
    
    
    func connectDataBase(){
                let hostName = "127.0.0.1";
                let dbName = "yuri";
                let userName = "root";
                let password = "594Risure";
        
//        let hostName = "db.soic.indiana.edu";
//        let dbName = "i494f17_yexi";
//        let userName = "i494f17_yexi i494f17_yexi";
//        let password = "my+sql=i494f17_yexi";
        
        
        let user = OHMySQLUser.init(userName: userName, password: password, serverName: hostName, dbName: dbName, port: 3306, socket: "/Applications/MAMP/tmp/mysql/mysql.sock")
        
        let coordinator = OHMySQLStoreCoordinator.init(user: user!)
        
        //        self.coordinator = coordinator
        //        let quryContext = OHMySQLQueryContext()
        
        self.queryContext.storeCoordinator = coordinator
        
        coordinator.connect()
    }
    
    func quryUserInfo(){
        
        let query = OHMySQLQueryRequestFactory.select("users", condition: nil)
        do {
            let tasks = try self.queryContext.executeQueryRequestAndFetchResult(query)
            print("users:\(tasks)")
            for dic in tasks {
                let aname:String = dic["name"] as! String
                let apswd:String = dic["password"] as! String
                
                if aname.isEqual("a") && apswd.isEqual("b") {
//                    self.dismiss(animated: true, completion: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "shouldCountLoginVC"), object: nil)
                    return
                }
            }
            let alert = UIAlertView.init(title: "failure!", message: "Check username or password", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
}
