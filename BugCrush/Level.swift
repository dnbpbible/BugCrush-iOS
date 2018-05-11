//
//  Level.swift
//  BugCrush
//
//  Created by Paul E. Bible on 5/11/18.
//  Copyright © 2018 Dave & Buster's, Inc. All rights reserved.
//

import Foundation

let numColumns = 9
let numRows = 9
let numLevels = 4

class Level {
    private var cookies = Array2D<Cookie>(columns: numColumns, rows: numRows)
    private var tiles = Array2D<Tile>(columns: numColumns, rows: numRows)
    private var possibleSwaps: Set<Swap> = []
    private var comboMultiplier = 0
    
    var targetScore = 0
    var maximumMoves = 0
    
    init(filename: String) {
        guard let levelData = LevelData.loadFrom(file: filename) else { return }
        let tilesArray = levelData.tiles
        for (row, rowArray) in tilesArray.enumerated() {
            let tileRow = numRows - row - 1
            for (column, value) in rowArray.enumerated() {
                if value == 1 {
                    tiles[column, tileRow] = Tile()
                }
            }
        }
        targetScore = levelData.targetScore
        maximumMoves = levelData.moves
    }
    
    func cookie(atColumn column: Int, row: Int) -> Cookie? {
        precondition(column >= 0 && column < numColumns)
        precondition(row >= 0 && row < numRows)
        return cookies[column, row]
    }
    
    func tileAt(column: Int, row: Int) -> Tile? {
        precondition(column >= 0 && column < numColumns)
        precondition(row >= 0 && row < numRows)
        return tiles[column, row]
    }
    
    func shuffle() -> Set<Cookie> {
        var set: Set<Cookie>
        repeat {
            set = createInitialCookies()
            detectPossibleSwaps()
            print("possible swaps: \(possibleSwaps)")
        } while possibleSwaps.count == 0
        return set
    }
    
    private func createInitialCookies() -> Set<Cookie> {
        var set: Set<Cookie> = []
        for row in 0..<numRows {
            for column in 0..<numColumns {
                if tiles[column, row] != nil {
                    var cookieType: CookieType
                    repeat {
                        cookieType = CookieType.random()
                    } while (column >= 2 &&
                        cookies[column - 1, row]?.cookieType == cookieType &&
                        cookies[column - 2, row]?.cookieType == cookieType)
                        || (row >= 2 &&
                            cookies[column, row - 1]?.cookieType == cookieType &&
                            cookies[column, row - 2]?.cookieType == cookieType)
                    let cookie = Cookie(column: column, row: row, cookieType: cookieType)
                    cookies[column, row] = cookie
                    set.insert(cookie)
                }
            }
        }
        return set
    }
    
    private func hasChain(atColumn column: Int, row: Int) -> Bool {
        let cookieType = cookies[column, row]!.cookieType
        
        // Horizontal chain check
        var horizontalLength = 1
        
        // Left
        var i = column - 1
        while i >= 0 && cookies[i, row]?.cookieType == cookieType {
            i -= 1
            horizontalLength += 1
        }
        
        // Right
        i = column + 1
        while i < numColumns && cookies[i, row]?.cookieType == cookieType {
            i += 1
            horizontalLength += 1
        }
        if horizontalLength >= 3 { return true }

        // Vertical chain check
        var verticalLength = 1

        // Down
        i = row - 1
        while i >= 0 && cookies[column, i]?.cookieType == cookieType {
            i -= 1
            verticalLength += 1
        }
        
        // Up
        i = row + 1
        while i < numRows && cookies[column, i]?.cookieType == cookieType {
            i += 1
            verticalLength += 1
        }
        
        return verticalLength >= 3
    }
    
    private func detectPossibleSwaps() {
        
    }
}
