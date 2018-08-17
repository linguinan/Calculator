//
//  ViewController.swift
//  Calculator
//
//  Created by Lgn on 2018/8/10.
//  Copyright © 2018年 All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var txtLabel: UILabel!
    
    var userHasInit: Bool = false
    
    var brain = CalculatorBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func onNumClick(_ sender: UIButton) {
        if(userHasInit)
        {
            txtLabel.text = txtLabel.text! + sender.currentTitle!
        }else{
            txtLabel.text = sender.currentTitle!
            userHasInit = true
        }
    }
    
    @IBAction func operate(_ sender: UIButton) {
        if userHasInit {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(symbol: operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    
    @IBAction func enter() {
        userHasInit = false
        if let result = brain.pushOperand(operand: displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    var displayValue: Double {
        get {
            return NumberFormatter().number(from: txtLabel.text!)!.doubleValue
        }
        set {
            txtLabel.text = "\(newValue)"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

