//
//  LevelUI.swift
//  RookJones
//
//  Created by Richard Pineo on 3/11/18.
//  Copyright © 2018 Richard Pineo. All rights reserved.
//

import Foundation

// Wraps a Level object with any properties needed to display in the UI.
class LevelUI {
    init(shortName: String, level: Level) {
        self.shortName = shortName
        self.level = level
    }

    let shortName: String
    let level: Level
}
