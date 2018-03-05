//
//  TitlePageViewController.swift
//  RookJones
//
//  Created by Richard Pineo on 2/22/18.
//  Copyright © 2018 Richard Pineo. All rights reserved.
//

import UIKit

class TitlePageViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.levels.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.levels[row].name
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectLevel(level: self.levels[row])
        selectLevelPicker.isHidden = true
        saveSelectedLevel(name: selectedLevel?.name)
    }
    
    func selectLevelByName(name: String?) {
        let level = self.levels.first(where: {
            return $0.name == name
        })
        selectLevel(level: level)
    }
    
    func selectLevel(level: Level?) {
        selectedLevel = level
        if( level != nil ) {
            selectLevelButton.setTitle("\(selectedLevel!.name)", for: .normal)
        }
        else {
            selectLevelButton.setTitle("Select Level", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectLevelPicker.delegate = self
        selectLevelPicker.dataSource = self
        loadLevels()
        loadPreviousLevel()
    }
    
    private func loadLevels() {
        self.levels = BoardLoader.loadLevels()
    }

    private var selectedLevel: Level?
    private var levels: Array<Level> = []

    @IBOutlet weak var selectLevelPicker: UIPickerView!
    @IBOutlet weak var selectLevelButton: UIButton!

    @IBAction func selectLevelAction(_ sender: UIButton) {
        if selectLevelPicker.isHidden {
            selectLevelPicker.isHidden = false
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        (segue.destination as! GameViewController).level = self.selectedLevel!
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return selectedLevel != nil
    }
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("level")

    private func saveSelectedLevel(name: String?) {
        NSKeyedArchiver.archiveRootObject(name as Any, toFile: TitlePageViewController.ArchiveURL.path)
    }
    
    private func loadPreviousLevel() {
        let name = NSKeyedUnarchiver.unarchiveObject(withFile: TitlePageViewController.ArchiveURL.path) as? String
        selectLevelByName(name: name)
    }
}
