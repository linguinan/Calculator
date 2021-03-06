//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Lgn on 2018/8/14.
//  Copyright © 2018年 All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    //Printable -> CustomStringConvertible
    private enum Op : CustomStringConvertible {
        case Operand(Double)
        case UnaryOperation(String, (Double) -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var konwnOps = [String:Op]()
    
    init() {
        konwnOps["×"] = Op.BinaryOperation("×", *)
        konwnOps["÷"] = Op.BinaryOperation("÷", { $1 / $0 })
        konwnOps["+"] = Op.BinaryOperation("+", +)
        konwnOps["−"] = Op.BinaryOperation("−", { $1 - $0 })
        konwnOps["√"] = Op.UnaryOperation("√", sqrt)
    }
    
    var program: AnyObject {
        get {
            return opStack.map { $0.description } as AnyObject
            //==
//            var res = Array<String>()
//            for op in opStack {
//                res.append(op.description)
//            }
//            return res as AnyObject
        }
        set {
            if let opSymbols = newValue as? Array<String> {
                var newOpStack = [Op]()
                for opSymbol in opSymbols {
                    if let op = konwnOps[opSymbol] {
                        newOpStack.append(op)
                    } else if let operand = NumberFormatter().number(from: opSymbol)?.doubleValue {
                        newOpStack.append(.Operand(operand))
                    }
                }
                opStack = newOpStack
            }
        }
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(ops: remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(ops: remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(ops: op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(ops: opStack)
        print("\(opStack) = \(String(describing: result)) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = konwnOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    
}
