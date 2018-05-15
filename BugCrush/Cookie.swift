//
//  Cookie.swift
//  BugCrush
//
//  Created by Paul E. Bible on 5/11/18.
//  Copyright © 2018 Dave & Buster's, Inc. All rights reserved.
//

import SpriteKit

// MARK: - CookieType
enum CookieType: Int {
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
    
    static func random() -> CookieType {
        return CookieType(rawValue: Int(arc4random_uniform(6)) + 1)!
    }
}

// MARK: - Cookie
class Cookie: CustomStringConvertible, Hashable {
    var column: Int
    var row: Int
    var cookieType: CookieType
    var sprite: SKSpriteNode?
    
    init(column: Int, row: Int, cookieType: CookieType) {
        self.column = column
        self.row = row
        self.cookieType = cookieType
    }
    
    var hashValue: Int {
        return row * 10 + column
    }
    
    static func ==(lhs: Cookie, rhs: Cookie) -> Bool {
        return lhs.column == rhs.column && lhs.row == rhs.row
    }
    
    var description: String {
        return "type:\(cookieType) square:(\(column),\(row))"
    }
}
