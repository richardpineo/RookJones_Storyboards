
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
