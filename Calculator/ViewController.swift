//
//  ViewController.swift
//  Calculator
//
//  Created by LiuXing on 2017/10/15.
//  Copyright © 2017年 xhGroup. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var mainLabel: UILabel!
    var isShowLogin : Bool!
    var logic : CalcLogic!
    
    @IBOutlet weak var welcomLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global().async {
            DBmanager.shared.connectDataBase()
        }
        // Do any additional setup after loading the view, typically from a nib.
        mainLabel.text = "0"
        logic = CalcLogic()
        
//        let a = "i494f17_yexi"
//        print(a)
//        print(a.MD5())
        
        
        let notificationCenter = NotificationCenter.default
        
        let operationQueue = OperationQueue.main
        self.isShowLogin = false
        _ = notificationCenter.addObserver(
            forName: NSNotification.Name(rawValue: "shouldCountLoginVC"),
            object: nil, queue: operationQueue, using: { (notification) in
                self.startCountLoginVC()
        })
        _ = notificationCenter.addObserver(
            forName: NSNotification.Name(rawValue: "loginSucess"),
            object: nil, queue: operationQueue, using: { (notification) in
                self.loginedSucess(noti:notification)
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !self.isShowLogin {
            self.shouldLogin()
            self.isShowLogin = true
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        logic = nil
    }
    
    
    
    
    //数字按钮
    @IBAction func numberButtonPressed(_ sender: AnyObject) {
        
        let btn : UIButton = sender as! UIButton
        //刷新label的值
        mainLabel.text = logic.updateMainLabelStringByNumberTag(btn.tag, withmainlabelString: mainLabel.text!)
    }
    
    //小数点按钮
    @IBAction func decimalPressed(_ sender: AnyObject) {
        if logic.doesStringContainDecimal(mainLabel.text!) == false {
            let string = mainLabel.text! + "."
            
            mainLabel.text = string
        }
        
    }
    
    //清除按钮
    @IBAction func clearPressed(_ sender: AnyObject) {
        
        mainLabel.text = "0"
        logic.clear()
    }
    
    //等于按钮
    @IBAction func eqalsPressed(_ sender: AnyObject) {
        
        let btn : UIButton = sender as! UIButton
        
        mainLabel.text = logic.calculateByTag(btn.tag, withmainlabelString: mainLabel.text!)
        
    }
    
    //运算符按钮
    @IBAction func operandPressed(_ sender: AnyObject) {
        
        let btn : UIButton = sender as! UIButton
        
        mainLabel.text = logic.calculateByTag(btn.tag, withmainlabelString: mainLabel.text!)
        
    }
    func shouldLogin() {
        let lv = LoginViewController()
        let preVC = UINavigationController.init(rootViewController: lv)
        self.present(preVC, animated: true, completion: nil)
    }
    
    func startCountLoginVC() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 60*15) {
            self.shouldLogin()
        }
//        let lv = LoginViewController()
//        self.present(lv, animated: true, completion: nil)
    }
    
    func loginedSucess(noti:Notification)  {
        let userName = noti.object as! String
        self.welcomLabel.text = "hello! "+userName
        
        
    }
}
 

