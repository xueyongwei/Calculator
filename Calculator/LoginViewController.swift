//
//  LoginViewController.swift
//  Calculator
//
//  Created by 薛永伟 on 2017/10/29.
//  Copyright © 2017年 xhGroup. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {
    
    @IBOutlet weak var userNameLabel: UITextField!
    
    @IBOutlet weak var passwordLabel: UITextField!
    
    lazy var queryContext: OHMySQLQueryContext = OHMySQLQueryContext()
    
//    var coordinator:OHMySQLStoreCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        DispatchQueue.global().async {
//            self.connectDataBase()
//        }
        
        let regBItm = UIBarButtonItem.init(title: "join", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goToRegist))
        self.navigationItem.rightBarButtonItem = regBItm
        
        
    }
    
    func goToRegist(){
        self.view.endEditing(false)
        let regVC = RegisterViewController()
        self.navigationController?.pushViewController(regVC, animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okClick(_ sender: UIButton) {
        if (userNameLabel.text?.characters.count==0 || userNameLabel.text?.characters.count==0){
            let alv = UIAlertView.init(title: "No input yet", message: "Check username or password", delegate: nil, cancelButtonTitle: "OK")
            alv.show()
            
            return;
        }
        
        self.quryUserInfo();
    }
    
//    func connectDataBase(){
//        let hostName = "127.0.0.1";
//        let dbName = "yuri";
//        let userName = "root";
//        let password = "594Risure";
//
////        let hostName = "db.soic.indiana.edu";
////        let dbName = "i494f17_yexi";
////        let userName = "i494f17_yexi i494f17_yexi";
////        let password = "my+sql=i494f17_yexi";
//
//
//        let user = OHMySQLUser.init(userName: userName, password: password, serverName: hostName, dbName: dbName, port: 3306, socket: "/Applications/MAMP/tmp/mysql/mysql.sock")
//
//        let coordinator = OHMySQLStoreCoordinator.init(user: user!)
//
////        self.coordinator = coordinator
////        let quryContext = OHMySQLQueryContext()
//
//        self.queryContext.storeCoordinator = coordinator
//
//
//
//        coordinator.connect()
//    }
    
    func quryUserInfo(){
        
        let query = OHMySQLQueryRequestFactory.select("users", condition: nil)
        do {
            let tasks = try DBmanager.shared.queryContext.executeQueryRequestAndFetchResult(query)
            print("users:\(tasks)")
            for dic in tasks {
                let aname:String = dic["name"] as! String
                let apswd:String = dic["password"] as! String
                
                if aname.isEqual(self.userNameLabel.text) && apswd.isEqual(self.passwordLabel.text?.MD5()) {
                    self.dismiss(animated: true, completion: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "shouldCountLoginVC"), object: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loginSucess"), object: self.userNameLabel.text)
                    return
                }
            }
            let alert = UIAlertView.init(title: "failure!", message: "Check username or password", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
