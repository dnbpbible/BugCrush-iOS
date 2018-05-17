//
//  Swap.swift
//  BugCrush
//
//  Created by Paul E. Bible on 5/11/18.
//  Copyright © 2018 Dave & Buster's, Inc. All rights reserved.
//

struct Swap: CustomStringConvertible, Hashable {
    let bugA: Bug
    let bugB: Bug
    
    init(bugA: Bug, bugB: Bug) {
        self.bugA = bugA
        self.bugB = bugB
    }
    
    var hashValue: Int {
        return bugA.hashValue ^ bugB.hashValue
    }
    
    static func ==(lhs: Swap, rhs: Swap) -> Bool {
        return (lhs.bugA == rhs.bugA && lhs.bugB == rhs.bugB) ||
            (lhs.bugB == rhs.bugA && lhs.bugA == rhs.bugB)
    }
    
    var description: String {
        return "swap \(bugA) with \(bugB)"
    }
}
