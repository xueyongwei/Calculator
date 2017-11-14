//
//  RegisterViewController.swift
//  Calculator
//
//  Created by 薛永伟 on 2017/11/13.
//  Copyright © 2017年 xhGroup. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var confirmLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var userNameLabel: UITextField!
    @IBOutlet weak var firstNameLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let regBItm = UIBarButtonItem.init(title: "create", style: UIBarButtonItemStyle.plain, target: self, action: #selector(onCreateCkick))
        self.navigationItem.rightBarButtonItem = regBItm
        
        // Do any additional setup after loading the view.
    }
    
    func onCreateCkick() {
        let username = self.userNameLabel.text
        let firstName = self.firstNameLabel.text
        let email = self.emailLabel.text
        let pasword = self.passwordLabel.text
        let confirm = self.confirmLabel.text
        
        if username?.count == 0 {
            let alert = UIAlertView.init(title: "error!", message: "input username", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            return
        }
        if firstName?.count == 0 {
            let alert = UIAlertView.init(title: "error!", message: "input firstName", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            return
        }
        if email?.count == 0 {
            let alert = UIAlertView.init(title: "error!", message: "input email", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            return
        }
        if pasword?.count == 0 {
            let alert = UIAlertView.init(title: "error!", message: "input password", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            return
        }
        if confirm?.count == 0 {
            let alert = UIAlertView.init(title: "error!", message: "input password confrim", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            return
        }
        
        if (pasword != confirm){
            let alert = UIAlertView.init(title: "error!", message: "Inconsistency of two inputs", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            return
        }
        if self.isExitOfNameOrEmail() {
            print("error ");
        }else{//不存在，可以创建
            self.createUser()
        }
    }
    
    func createUser() {
        let query = OHMySQLQueryRequestFactory.insert("users", set: ["name": self.userNameLabel.text!,"password":self.passwordLabel.text!.MD5(), "firstname":self.firstNameLabel.text!, "email":self.emailLabel.text!])
        
            try?DBmanager.shared.queryContext.execute(query)
        self.navigationController?.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loginSucess"), object: self.userNameLabel.text)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isExitOfNameOrEmail() -> (Bool){
        
        let query = OHMySQLQueryRequestFactory.select("users", condition: nil)
        do {
            let tasks = try DBmanager.shared.queryContext.executeQueryRequestAndFetchResult(query)
            print("users:\(tasks)")
            for dic in tasks {
                let aname:String = dic["name"] as! String
                let email:String = dic["email"] as! String
                
                if aname.isEqual(self.userNameLabel.text) {
                    let alert = UIAlertView.init(title: "error!", message: "username already exists", delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                    return true
                } else if  email.isEqual(self.emailLabel.text) {
                    let alert = UIAlertView.init(title: "error!", message: "email already exists", delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                    return true
                }else{
                    
                }
            }
        } catch {
            print(error.localizedDescription)
            return true
        }
        return false
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
