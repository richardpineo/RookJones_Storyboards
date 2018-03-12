//
//  BundleSelectionViewController.swift
//  RookJones
//
//  Created by Richard Pineo on 3/10/18.
//  Copyright © 2018 Richard Pineo. All rights reserved.
//

import UIKit

private let reuseIdentifier = "LevelCell"

class BundleSelectionViewController: UICollectionViewController {

    private var levelBundles: [LevelBundle]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        let loader = LevelBundleLoader()
        self.levelBundles = loader.levelBundles
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.levelBundles!.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.levelBundles![section].levels.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LevelCollectionViewCell
        
        let level = self.levelBundles![indexPath.section].levels[indexPath.item]
        
        // Configure the cell
        let red = (Double(indexPath.section)+1.0) / 5.0;
        let green = (Double(indexPath.item)+1.0) / 20.0;
        let color = UIColor(displayP3Red: CGFloat(red), green: CGFloat(green), blue: 0.5, alpha: 0.5)
        cell.backgroundColor = color
        
        cell.shortName.text = level.shortName
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if( kind == UICollectionElementKindSectionHeader ) {
            let bundleHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind, withReuseIdentifier: "Bundle", for: indexPath) as! BundleCollectionReusableView
            
            let levelBundle = self.levelBundles![indexPath.section]
            bundleHeader.bundleLabel.text = levelBundle.name
            bundleHeader.backgroundColor = levelBundle.backgroundColor
            return bundleHeader
        }
        
        assert(false, "Unexpected element kind")
    }
    
    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // User picked an item, segue to level
    }
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
