//
//  Cookie.swift
//  BugCrush
//
//  Created by Paul E. Bible on 5/11/18.
//  Copyright © 2018 Dave & Buster's, Inc. All rights reserved.
//

import SpriteKit

// MARK: - BugType
enum BugType: Int {
    case unknown = 0, bee, bug, ladybug, leafbettle, starbeetle, strinkbug
    
    var spriteName: String {
        let spriteNames = [
            "Bee",
            "Bug",
            "LadyBug",
            "LeafBeetle",
            "StarBeetle",
            "StinkBug"]
        
        return spriteNames[rawValue - 1]
    }
    
    var highlightedSpriteName: String {
        return spriteName + "-Highlighted"
    }
    
    static func random() -> BugType {
        return BugType(rawValue: Int(arc4random_uniform(6)) + 1)!
    }
}

// MARK: - Bug
class Bug: CustomStringConvertible, Hashable {
    var column: Int
    var row: Int
    var cookieType: BugType
    var sprite: SKSpriteNode?
    
    init(column: Int, row: Int, cookieType: BugType) {
        self.column = column
        self.row = row
        self.cookieType = cookieType
    }
    
    var hashValue: Int {
        return row * 10 + column
    }
    
    static func ==(lhs: Bug, rhs: Bug) -> Bool {
        return lhs.column == rhs.column && lhs.row == rhs.row
    }
    
    var description: String {
        return "type:\(cookieType) square:(\(column),\(row))"
    }
}
