//
//  Chain.swift
//  BugCrush
//
//  Created by Paul E. Bible on 5/11/18.
//  Copyright © 2018 Dave & Buster's, Inc. All rights reserved.
//

class Chain: CustomStringConvertible, Hashable {
    var bugs: [Bug] = []
    var score = 0
    var chainType: ChainType

    enum ChainType: CustomStringConvertible {
        case horizontal
        case vertical
        
        var description: String {
            switch self {
                case .horizontal: return "Horizontal"
                case .vertical: return "Vertical"
            }
        }
    }
    
    init(chainType: ChainType) {
        self.chainType = chainType
    }
    
    func add(bug: Bug) {
        bugs.append(bug)
    }
    
    func firstBug() -> Bug {
        return bugs[0]
    }
    
    func lastBug() -> Bug {
        return bugs[bugs.count - 1]
    }
    
    var length: Int {
        return bugs.count
    }
    
    var description: String {
        return "type:\(chainType) bugs:\(bugs)"
    }
    
    var hashValue: Int {
        return bugs.reduce (0) { $0.hashValue ^ $1.hashValue }
    }
    
    static func ==(lhs: Chain, rhs: Chain) -> Bool {
        return lhs.bugs == rhs.bugs
    }
}
