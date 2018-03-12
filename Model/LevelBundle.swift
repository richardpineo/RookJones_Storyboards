//
//  LevelBundle.swift
//  RookJones
//
//  Created by Richard Pineo on 3/11/18.
//  Copyright © 2018 Richard Pineo. All rights reserved.
//

import UIKit

class LevelBundle {
    init(name: String, backgroundColor: UIColor) {
        self.name = name
        self.backgroundColor = backgroundColor
        self.levels = Array<LevelUI>()
    }
    
    let name: String
    let backgroundColor: UIColor
    var levels: Array<LevelUI>
}
