//
//  LevelData.swift
//  BugCrush
//
//  Created by Paul E. Bible on 5/11/18.
//  Copyright © 2018 Dave & Buster's, Inc. All rights reserved.
//

import Foundation

class LevelData: Codable {
    let tiles: [[Int]]
    let targetScore: Int
    let background: Int
    let moves: Int

    static func loadFrom(file filename: String) -> LevelData? {
        var data: Data
        var levelData: LevelData?
        
        if let path = Bundle.main.url(forResource: filename, withExtension: "json") {
            do {
                data = try Data(contentsOf: path)
            }
            catch {
                print("Could not load level file: \(filename), error: \(error)")
                return nil
            }
            do {
                let decoder = JSONDecoder()
                levelData = try decoder.decode(LevelData.self, from: data)
            }
            catch {
                print("Level file '\(filename)' is not valid JSON: \(error)")
                return nil
            }
        }
        return levelData
    }
}
