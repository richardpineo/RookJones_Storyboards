
import GameplayKit
import SpriteKit
import UIKit

class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Listen for a notification to tell us to go back to the title screen
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.onBackToTitle), name: NSNotification.Name(rawValue: "BackToTitle"), object: nil)

        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                // Set the level in the scene
                sceneNode.initialBoard = level?.board

                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs

                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill

                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)

                    view.ignoresSiblingOrder = true

                    // view.showsFPS = true
                    // view.showsNodeCount = true
                }
            }
        }
    }

    var level: Level?

    @objc func onBackToTitle(notification _: NSNotification) {
        performSegue(withIdentifier: "BackToTitle", sender: self)
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
