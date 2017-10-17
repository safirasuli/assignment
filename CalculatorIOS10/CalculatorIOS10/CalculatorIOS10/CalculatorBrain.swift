//
//  CalculatorBrain.swift
//  CalculatorIOS10
//
//  Created by Admin on 05.10.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation

func changeSign(operand: Double)-> Double {
    return -operand
}


struct CalculatorBrain{
    
    private var accumulator: Double?
    private var descriptionAccumulator: String = " "
    private var resultIsPending: Bool = true
    
    var description: String?  {
        get{
            var resultDescription: String
            
            if resultIsPending{
                resultDescription = descriptionAccumulator + "..."
            } else {
                resultDescription = descriptionAccumulator + "="
                
            }
            
            
            return resultDescription
        }
    }
    
    
    private enum Operation {
        case constant(Double, String)
        case unaryOperation((Double) -> Double, (String) -> String)
        case binaryOperation((Double, Double) -> Double, (String, String) -> String, String, Bool)
        case equals
    }
    
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.constant(Double.pi, "π"),
        "e" : Operation.constant(M_E, "M_E"),
        "√" : Operation.unaryOperation(sqrt, {"√\($0)"} ), //sqrt
        "cos": Operation.unaryOperation(cos, {"cos\($0)"}), //cos
        "tan": Operation.unaryOperation(tan, {"tan\($0)"} ),
        "x⁻¹": Operation.unaryOperation({1 / $0}, {"\($0)⁻¹"}),
        "x²": Operation.unaryOperation({$0 * $0}, {"\($0)²"}),
        "±" : Operation.unaryOperation(changeSign, { "-\($0)" }),
        "×" : Operation.binaryOperation({$0 * $1} ,{ "\($0) x \($1)"}, "×",  true ),
        "−" : Operation.binaryOperation({$0 - $1}, { "\($0) - \($1  )" }, "-",  false),
        "÷" : Operation.binaryOperation({$0 / $1}, { "\($0) / \($1)" }, "/",  true ),
        "+" : Operation.binaryOperation({$0 + $1}, { "\($0) + \($1)"}, "+",  false ),
        "=" : Operation.equals
    ]
    //even haakjes opzoeken in het engels
    private func setHaakjes(descriptionString: String) -> String{
        return "(\(descriptionString))"
    }
    
    mutating func performOperation(_ symbol: String){
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value, _):
                accumulator = value
                descriptionAccumulator += "\(symbol)"
                break
            case .unaryOperation(let function, let descriptionUnary):
                if accumulator != nil{
                    if resultIsPending {
                        descriptionAccumulator += "(" + descriptionUnary(String(accumulator!)) + ")"
                    } else {
                        descriptionAccumulator = "(" + descriptionUnary(descriptionAccumulator) + ")"
                    }
                    
                    print(" operation is: (", descriptionAccumulator)
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function, let descriptionBin, let operation, let firstToExecute):
                //altijd als het
//                if firstToExecute{
//                    descriptionAccumulator = "(" + " \(descriptionAccumulator!)" + ")"
                //                }
                if resultIsPending {
                    descriptionAccumulator += String(accumulator!) + "\(symbol)"
                    performPendingBinaryOperation()
                }
                
                if accumulator != nil{
                    pendingBinaryOperation = PendingBinaryOperation(function: function, descriptionBinary: descriptionBin, firstOperand: accumulator!)
                    resultIsPending = true
                    
                }
                
                break
            case .equals:
                    descriptionAccumulator += String(accumulator!)
                
                performPendingBinaryOperation()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation(){
        if pendingBinaryOperation != nil && accumulator != nil{
           // descriptionAccumulator = pendingBinaryOperation!.descriptionBinary(String(pendingBinaryOperation!.firstOperand), String(accumulator!))
//            if resultIsPending {
//                partialResult += pendingBinaryOperation!.perform(with: accumulator!)
//            } else{
                accumulator = pendingBinaryOperation!.perform(with: accumulator!)
//            }
            pendingBinaryOperation = nil
        }
        
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        
        let function: (Double, Double) -> Double
        var descriptionBinary: (String, String) -> String
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double{
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double){
        accumulator = operand
        
       // print(" operand is: ", descriptionAccumulator!)
    }
    
    var partialResult: Double = 0.0
    
    var result: Double? {
        get {
            if resultIsPending {
               // return partialResult + accumulator!
            }
            return accumulator
        }
    }
    
   mutating func clear(){
        descriptionAccumulator = " "
        accumulator = nil
        pendingBinaryOperation = nil
        
    }

}

