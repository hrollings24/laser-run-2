//
//  GameViewController.swift
//  Laser Run 2
//
//  Created by Harry Rollings on 29/06/2020.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds

class GameViewController: UIViewController, GADFullScreenContentDelegate {
    
    var previousLoc = CGPoint.init(x: UIScreen.main.bounds.size.width/2 , y: (UIScreen.main.bounds.size.height/5 * 4)+30)
    var scene: GameScene!
    var mode: Mode!
    var chosenTheme: String!
    var tapGesture: UIPanGestureRecognizer!
    var endVC: EndViewController!
    private var interstitial: GADInterstitialAd?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let adverts = Ads(vct: self)
        adverts.createBannerView()
        
        self.view.backgroundColor = .clear
        self.view.isOpaque = false
        
        let skView = self.view as? SKView

        if skView?.scene == nil  {
            skView?.ignoresSiblingOrder = false

            scene = GameScene(size: UIScreen.main.bounds.size)
            scene.gameVC = self
            scene.mode = mode
            scene.setupGame()
            scene.scaleMode = .aspectFill
            skView?.presentScene(scene)
        }
        
        tapGesture = UIPanGestureRecognizer(target: self, action:#selector(move))
        skView?.addGestureRecognizer(tapGesture)
        loadAd()
        
    }
    
    func loadScene(){
        scene.addBackground()
    }
    
    func setCharacterStart(){
        if mode != .reverse{
            scene.playerObject.position = CGPoint(x: -20, y: scene.frame.height / 5 + 20)
            scene.startNode.position = CGPoint(x: scene.frame.width + scene.startNode.frame.width, y: scene.frame.height / 3 * 2)
            scene.scoreLB.position = CGPoint(x: -scene.scoreLB.frame.minX - 20 , y: scene.frame.height - 50)
        }
        else{
            scene.playerObject.position = CGPoint(x: scene.frame.width / 2, y: scene.frame.height + 10)
        }
    }
    
    func setCharacterEnd(){
        if mode != .reverse{
            let act = SKAction.move(to: CGPoint(x: scene.frame.width / 2, y: scene.frame.height / 5 + 20), duration: 0.5)
            scene.playerObject.run(act)
            let act2 = SKAction.move(to: CGPoint(x: scene.frame.width / 2 , y: scene.frame.height / 3 * 2), duration: 0.5)
            scene.startNode.run(act2)
            let act3 = SKAction.move(to: CGPoint(x: (scene.frame.width + 40) - scene.frame.width , y: scene.frame.height - 50), duration: 0.5)
            scene.scoreLB.run(act3)

        }
        else{
            scene.playerObject.position = CGPoint(x: scene.frame.width / 2, y: ((scene.frame.height / 5) * 4))
        }
    }
    
    @objc func move(sender: UIPanGestureRecognizer){
        if scene.playerObject.isAlive{
            var delta = sender.translation(in: self.view)
            let loc = sender.location(in: self.view)

            if sender.state == .changed {
                delta = CGPoint.init(x: 2 * (loc.x - previousLoc.x), y: 2 * (loc.y - previousLoc.y))
               if scene.playerObject.position.x + CGFloat(delta.x * 0.6) > scene.frame.width{
                   scene.setPositionOfObject(x: scene.frame.width)
               }
               else if scene.playerObject.position.x + CGFloat(delta.x * 0.6) < 0{
                   scene.setPositionOfObject(x: 0)
               }
               else{
                   scene.setPositionOfObject(x: scene.playerObject.position.x + CGFloat(delta.x * 0.6))
               }
               previousLoc = loc
            }
           previousLoc = loc
        }
     }
    
    func died(){
        let value = UserDefaults.standard.value(forKey: "removedAds") as! Bool
        if !value{
            if let interstitialAd = interstitial {
                interstitialAd.present(fromRootViewController: self)
            }
            else {
                setupEndVC(withTime: 0.5)
            }
        }
        else {
            setupEndVC(withTime: 0.5)
        }
    }
    
    func removePan(){
        let skView = self.view as? SKView
        skView!.gestureRecognizers?.forEach(skView!.removeGestureRecognizer)
    }
    
    func setupEndVC(withTime: TimeInterval){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        endVC = mainStoryboard.instantiateViewController(withIdentifier: "end") as? EndViewController
        endVC.score = scene.score
        endVC.mode = mode
        self.scene.gameVC = nil
        self.scene = nil
        root.changeView(fromvc: self, tovc: endVC, animation: .transitionCrossDissolve, duration: withTime)
    }
   
    
    func launchMe(){
        self.scene.gameVC = nil
        self.scene = nil
        self.dismiss(animated: false){
            self.endVC = nil
        }
    }
    
   

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func loadAd() {
         let value = UserDefaults.standard.value(forKey: "removedAds") as? Bool ?? false
         if !value {
             let request = GADRequest()
             GADInterstitialAd.load(withAdUnitID: AdIDs.intID, request: request) { [weak self] ad, error in
                 if let error = error {
                     print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                     return
                 }
                 self?.interstitial = ad
                 self?.interstitial?.fullScreenContentDelegate = self
             }
         }
     }
    
     func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
         setupEndVC(withTime: 0.0)
     }

     func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
         print("Ad did dismiss full screen content.")
     }
    
}
