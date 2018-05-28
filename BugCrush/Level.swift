//
//  Level.swift
//  BugCrush
//
//  Created by Paul E. Bible on 5/11/18.
//  Copyright © 2018 Dave & Buster's, Inc. All rights reserved.
//

import Foundation

let numColumns = 11
let numRows = 11
let numLevels = 5

class Level {
    private var bugs = Array2D<Bug>(columns: numColumns, rows: numRows)
    private var tiles = Array2D<Tile>(columns: numColumns, rows: numRows)
    private var possibleSwaps: Set<Swap> = []
    private var comboMultiplier = 0
    
    var targetScore = 0
    var maximumMoves = 0
    var background = 0
    
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
        background = levelData.background
    }
    
    func bug(atColumn column: Int, row: Int) -> Bug? {
        precondition(column >= 0 && column < numColumns)
        precondition(row >= 0 && row < numRows)
        return bugs[column, row]
    }
    
    func tileAt(column: Int, row: Int) -> Tile? {
        precondition(column >= 0 && column < numColumns)
        precondition(row >= 0 && row < numRows)
        return tiles[column, row]
    }
    
    func shuffle() -> Set<Bug> {
        var set: Set<Bug>
        repeat {
            set = createInitialBugs()
            detectPossibleSwaps()
            print("possible swaps: \(possibleSwaps)")
        } while possibleSwaps.count == 0
        return set
    }
    
    private func createInitialBugs() -> Set<Bug> {
        var set: Set<Bug> = []
        print("Rows: \(numRows), Columns: \(numColumns)")
        for row in 0..<numRows {
            for column in 0..<numColumns {
                print("Rows \(row), Column: \(column)")
                if tiles[column, row] != nil {
                    var bugType: BugType
                    repeat {
                        bugType = BugType.random()
                    } while (column >= 2 &&
                        bugs[column - 1, row]?.bugType == bugType &&
                        bugs[column - 2, row]?.bugType == bugType)
                        || (row >= 2 &&
                            bugs[column, row - 1]?.bugType == bugType &&
                            bugs[column, row - 2]?.bugType == bugType)
                    let bug = Bug(column: column, row: row, bugType: bugType)
                    bugs[column, row] = bug
                    print("Bug for Row \(row), Column \(column)")
                    set.insert(bug)
                }
            }
        }
        return set
    }
    
    private func hasChain(atColumn column: Int, row: Int) -> Bool {
        let bugType = bugs[column, row]!.bugType
        
        // Horizontal chain check
        var horizontalLength = 1
        
        // Left
        var i = column - 1
        while i >= 0 && bugs[i, row]?.bugType == bugType {
            i -= 1
            horizontalLength += 1
        }
        
        // Right
        i = column + 1
        while i < numColumns && bugs[i, row]?.bugType == bugType {
            i += 1
            horizontalLength += 1
        }
        if horizontalLength >= 3 { return true }

        // Vertical chain check
        var verticalLength = 1

        // Down
        i = row - 1
        while i >= 0 && bugs[column, i]?.bugType == bugType {
            i -= 1
            verticalLength += 1
        }
        
        // Up
        i = row + 1
        while i < numRows && bugs[column, i]?.bugType == bugType {
            i += 1
            verticalLength += 1
        }
        
        return verticalLength >= 3
    }
    
    func detectPossibleSwaps() {
        var set: Set<Swap> = []
        for row in 0..<numRows {
            for column in 0..<numColumns {
                if column < numColumns - 1,
                    let bug = bugs[column, row] {
                    
                    // Has a bug in this spot? If no tile, then no bug
                    if let other = bugs[column + 1, row] {

                        // Swap them
                        bugs[column, row] = other
                        bugs[column + 1, row] = bug
                        
                        // Is either bug now part of a chain?
                        if hasChain(atColumn: column + 1, row: row) ||
                            hasChain(atColumn: column, row: row) {
                            set.insert(Swap(bugA: bug, bugB: other))
                        }
                        
                        // Swap them back
                        bugs[column, row] = bug
                        bugs[column + 1, row] = other
                    }
                    if row < numRows - 1,
                        let other = bugs[column, row + 1] {
                        
                        // Swap them
                        bugs[column, row] = other
                        bugs[column, row + 1] = bug
                        
                        // Is either bug now part of a chain?
                        if hasChain(atColumn: column, row: row + 1) ||
                            hasChain(atColumn: column, row: row) {
                            set.insert(Swap(bugA: bug, bugB: other))
                        }
                        
                        // Swap them back
                        bugs[column, row] = bug
                        bugs[column, row + 1] = other
                    }
                }
            }
        }
        possibleSwaps = set
    }
    
    func performSwap(_ swap: Swap) {
        let columnA = swap.bugA.column
        let rowA = swap.bugA.row
        let columnB = swap.bugB.column
        let rowB = swap.bugB.row
        
        bugs[columnA, rowA] = swap.bugB
        swap.bugB.column = columnA
        swap.bugB.row = rowA
        
        bugs[columnB, rowB] = swap.bugA
        swap.bugA.column = columnB
        swap.bugA.row = rowB
    }
    
    func isPossibleSwap(_ swap: Swap) -> Bool {
        return possibleSwaps.contains(swap)
    }
    
    func detectHorizontalMatches() -> Set<Chain> {
        var set: Set<Chain> = []
        for row in 0..<numRows {
            var column = 0
            while column < numColumns - 2 {
                if let bug = bugs[column, row] {
                    let matchType = bug.bugType
                    if bugs[column + 1, row]?.bugType == matchType &&
                        bugs[column + 2, row]?.bugType == matchType {
                        let chain = Chain(chainType: .horizontal)
                        repeat {
                            chain.add(bug: bugs[column, row]!)
                            column += 1
                        } while column < numColumns && bugs[column, row]?.bugType == matchType
                        set.insert(chain)
                        continue
                    }
                }
                column += 1
            }
        }
        return set
    }
    
    func detectVerticalMatches() -> Set<Chain> {
        var set: Set<Chain> = []
        for column in 0..<numColumns {
            var row = 0
            while row < numRows - 2 {
                if let bug = bugs[column, row] {
                    let matchType = bug.bugType
                    if bugs[column, row + 1]?.bugType == matchType &&
                        bugs[column, row + 2]?.bugType == matchType {
                        let chain = Chain(chainType: .vertical)
                        repeat {
                            chain.add(bug: bugs[column, row]!)
                            row += 1
                        } while row < numRows && bugs[column, row]?.bugType == matchType
                        set.insert(chain)
                        continue
                    }
                }
                row += 1
            }
        }
        return set
    }
    
    func removeMatches() -> Set<Chain> {
        let horizontalChains = detectHorizontalMatches()
        let verticalChains = detectVerticalMatches()

        removeBugs(in: horizontalChains)
        removeBugs(in: verticalChains)
        
        calculateScores(for: horizontalChains)
        calculateScores(for: verticalChains)
        
        return horizontalChains.union(verticalChains)
    }
    
    func removeBugs(in chains: Set<Chain>) {
        for chain in chains {
            for bug in chain.bugs {
                bugs[bug.column, bug.row] = nil
            }
        }
    }
    
    func fillHoles() -> [[Bug]] {
        var columns: [[Bug]] = []
        for column in 0..<numColumns {
            var array = [Bug]()
            for row in 0..<numRows {
                if tiles[column, row] != nil && bugs[column, row] == nil {
                    for lookup in (row + 1)..<numRows {
                        if let bug = bugs[column, lookup] {
                            bugs[column, lookup] = nil
                            bugs[column, row] = bug
                            bug.row = row
                            array.append(bug)
                            break
                        }
                    }
                }
            }
            if !array.isEmpty {
                columns.append(array)
            }
        }
        return columns
    }
    
    func topUpBugs() -> [[Bug]] {
        var columns: [[Bug]] = []
        var bugType: BugType = .unknown
        for column in 0..<numColumns {
            var array: [Bug] = []
            var row = numRows - 1
            while row >= 0 && bugs[column, row] == nil {
                if tiles[column, row] != nil {
                    var newBugType: BugType
                    repeat {
                        newBugType = BugType.random()
                    } while newBugType == bugType
                    bugType = newBugType
                    let bug = Bug(column: column, row: row, bugType: bugType)
                    bugs[column, row] = bug
                    array.append(bug)
                }
                row -= 1
            }
            if !array.isEmpty {
                columns.append(array)
            }
        }
        return columns
    }
    
    func calculateScores(for chains: Set<Chain>) {
        // 3-chain is 60 pts, 4-chain is 120, 5-chain is 180, etc.
        for chain in chains {
            chain.score = 60 * (chain.length - 2)
            comboMultiplier += 1
        }
    }
    
    func resetComboMultiplier() {
        comboMultiplier = 1
    }
}
