

import UIKit

class LevelBundleLoader {
    init() {
        levelBundles = Array<LevelBundle>()
        let levels = BoardLoader.loadLevels()
        loadTests(levels: levels)
        loadDiamonds(levels: levels)
    }

    private func loadTests(levels: [Level]) {
        let backgroundColor = UIColor(red: 0.85, green: 0.89, blue: 1.00, alpha: 1.0)
        let demonstrations = LevelBundle(name: "Demonstration Levels", backgroundColor: backgroundColor)
        addLevel(levelBundle: demonstrations, levels: levels, fileName: "Test_00", shortName: "01")
        addLevel(levelBundle: demonstrations, levels: levels, fileName: "Test_01", shortName: "02")
        levelBundles.append(demonstrations)
    }

    private func loadDiamonds(levels: [Level]) {
        let backgroundColor = UIColor(red: 0.98, green: 0.93, blue: 0.33, alpha: 1.0)
        let diamonds = LevelBundle(name: "Dungeon of Diamonds", backgroundColor: backgroundColor)
        addLevel(levelBundle: diamonds, levels: levels, fileName: "Diamonds_03", shortName: "03")
        addLevel(levelBundle: diamonds, levels: levels, fileName: "Diamonds_07", shortName: "07")
        addLevel(levelBundle: diamonds, levels: levels, fileName: "Diamonds_08", shortName: "08")
        addLevel(levelBundle: diamonds, levels: levels, fileName: "Diamonds_13", shortName: "13")
        addLevel(levelBundle: diamonds, levels: levels, fileName: "Diamonds_17", shortName: "17")
        levelBundles.append(diamonds)
    }

    private func addLevel(levelBundle: LevelBundle, levels: [Level], fileName: String, shortName: String) {
        let level = findLevel(levels: levels, name: fileName)
        if level != nil {
            levelBundle.levels.append(LevelUI(shortName: shortName, level: level!))
        }
    }

    private func findLevel(levels: [Level], name: String) -> Level? {
        return levels.first(where: { (level) -> Bool in
            level.name == name
        })
    }

    var levelBundles: Array<LevelBundle>
}
