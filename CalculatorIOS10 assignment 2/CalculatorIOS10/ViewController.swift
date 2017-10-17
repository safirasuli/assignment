//
//  ViewController.swift
//  CalculatorIOS10
//
//  Created by Admin on 05.10.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var userIsIntheMiddleOfTyping = false
    @IBAction func clear(_ sender: UIButton){
        brain.clear()
        displayValue = 0
        descriptionValue = " "
        userIsIntheMiddleOfTyping = false
    }
    @IBAction func touchDigit(_ sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        //hou digit tegen als er een dubbel punt in zit.
        if digit == "." && display.text!.contains(".") {
            return;
        }
        if userIsIntheMiddleOfTyping {
        let textCurrentlyInDisplay = display.text!
        display.text = textCurrentlyInDisplay + digit
        } else {
            display!.text = digit
            userIsIntheMiddleOfTyping = true
        }
       
    }
    var displayValue: Double {
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    
    var  descriptionValue: String{
        get{
            return descriptionLabel.text!
        }
        set{
            descriptionLabel.text = String(newValue)
        }
    }
     private var brain = CalculatorBrain()
    //private var brain = CalculatorBrain()
    
    @IBAction func perforOperation(_ sender: UIButton) {
        if userIsIntheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsIntheMiddleOfTyping = false
        }
        userIsIntheMiddleOfTyping = false
        if let mathematicalSymbol = sender.currentTitle{
            brain.performOperation(mathematicalSymbol)
            if let result = brain.result{
                displayValue = result
            }
        }
        if let description = brain.description{
            descriptionValue = description
        }
    }
    
}

