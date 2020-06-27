//
//  BundleSelectionViewController.swift
//  RookJones
//
//  Created by Richard Pineo on 3/10/18.
//  Copyright © 2018 Richard Pineo. All rights reserved.
//

import UIKit

private let reuseIdentifier = "LevelCell"

class SelectLevelViewController: UICollectionViewController {
    private var levelBundles: [LevelBundle]?
    private var selectedLevel: Level?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        let loader = LevelBundleLoader()
        levelBundles = loader.levelBundles

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        // Pass the selected object to the new view controller.
        let dest = segue.destination
        (dest as! GameViewController).level = selectedLevel!
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in _: UICollectionView) -> Int {
        return levelBundles!.count
    }

    override func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levelBundles![section].levels.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LevelCollectionViewCell

        let levelBundle = levelBundles![indexPath.section]
        let level = levelBundles![indexPath.section].levels[indexPath.item]

        // Configure the cell
        cell.backgroundColor = levelBundle.backgroundColor.withAlphaComponent(0.5)
        cell.shortName.text = level.shortName

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let bundleHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind, withReuseIdentifier: "Bundle", for: indexPath) as! BundleCollectionReusableView

            let levelBundle = levelBundles![indexPath.section]
            bundleHeader.bundleLabel.text = levelBundle.name
            bundleHeader.backgroundColor = levelBundle.backgroundColor
            return bundleHeader
        }

        assert(false, "Unexpected element kind")
    }

    // If they clicked on a level they can play, then play!
    override func collectionView(_: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let level = levelBundles?[indexPath.section].levels[indexPath.item]
        selectedLevel = level?.level
        return selectedLevel != nil
    }
}
