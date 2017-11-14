//
//  CalcLogic.swift
//  CalculatorDemo
//
//  Created by zhangwenjun on 16/6/29.
//  Copyright © 2016年 zcgt_ios_01. All rights reserved.
//

import Foundation

enum Operator : Int {
    case plus = 200, minus, multiply, divide
    case `default` = 0
}


class CalcLogic {
    
    //保存上一次的值
    var lastRetainValue : Double
    //最近一次选择的操作符（枚举类型）
    var opr : Operator
    //临时保存MainLabel内容，为true时输入数字MainLabel内容被清为0
    var isMainlabelTextTemporary : Bool
    
    
    //初始化数据
    init () {
        lastRetainValue = 0.0
        isMainlabelTextTemporary = false
        opr = .default
    }
    
    //数字，操作符的输入处理
    func updateMainLabelStringByNumberTag(_ tag : Int, withmainlabelString mainlabelString : String) -> String {
        var string = mainlabelString
        
        
        //判断主标签代码是否是临时的，输入操作符后会变成true
        if (isMainlabelTextTemporary) {
            string = "0"
            isMainlabelTextTemporary = false
        }
        
        
        let optNumber = tag - 100
        //把string转为double（括号里面的语句是把swift的字符串转换为oc的字符串）
        let mainLabelDouble = (string as NSString).doubleValue
        
        
        //多次输入0的情况，输入0后再输入其他数
        if mainLabelDouble == 0 && doesStringContainDecimal(string) == false {
            return String(optNumber)
        }
        //拼接字符串
        let resultString = string + String(optNumber)
        return resultString
    }
    

    
    //运算
    func calculateByTag(_ tag : Int, withmainlabelString mainLabelString : String)->String{
        
        
        //把string转为double，小数点后只有0数据会自动变成整型
        let currentValue = (mainLabelString as NSString).doubleValue
        
        switch opr {
        case .plus:
            lastRetainValue += currentValue
        case .minus:
            lastRetainValue -= currentValue
        case .multiply:
            lastRetainValue *= currentValue
        case .divide:
            if lastRetainValue != 0{
                lastRetainValue /= currentValue
            }else{
                opr = .default
                isMainlabelTextTemporary = true
                return "错误"
            }
  
        default://保存上一次的值
            lastRetainValue = currentValue
        }
        
        //记得当前的操作符，下次计算是使用
        opr = Operator(rawValue : tag)!
        
        isMainlabelTextTemporary = true

        
        let resultString = String(format:"%g", lastRetainValue)
        
        return resultString 
        
    }
    
    //清除方法
    func clear(){
        lastRetainValue = 0.0
        isMainlabelTextTemporary = false
        opr = .default
    }
    
    
    //判断是否包含有小数点（有小数点就返回true）
    func doesStringContainDecimal(_ string : String) -> Bool {
        for ch in string.characters{//（有变化）
            if ch == "." {
                return true
            }
        }
        return false
    }
}
