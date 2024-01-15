//
//  MenuViewController.swift
//  Laser Run 2
//
//  Created by Harry Rollings on 29/06/2020.
//

import UIKit
import GameKit
import GoogleMobileAds
//import AppTrackingTransparency

class MenuViewController: UIViewController{

    @IBOutlet weak var logo: UILabel!
   
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var leaderboardBtn: UIButton!
    @IBOutlet weak var modesBtn: UIButton!
    @IBOutlet weak var storeBtn: UIButton!
    @IBOutlet weak var settings: UIButton!
    static var chosenTheme: String!

    var count: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        view.isOpaque = false

        //Set text properties
        logo.font = UIFont(name: "Potra", size: FontSizer.init().setCustomFont(baseFont: 64))
        let fontsize = FontSizer.init().setCustomFont(baseFont: 46)
        playBtn.titleLabel?.font = UIFont(name: "Potra", size: fontsize)
        modesBtn.titleLabel?.font = UIFont(name: "Potra", size: fontsize)
        leaderboardBtn.titleLabel?.font = UIFont(name: "Potra", size: fontsize)
        storeBtn.titleLabel?.font = UIFont(name: "Potra", size: fontsize)
        
        //Database
        if UserDefaults.standard.value(forKey: "initalised") == nil{
            //INITALISE DB
            initaliseDB()
            UserDefaults.standard.setValue("true", forKey: "initalised")
        }
        else{
            
        }
        
        //Set ad properties
       
        /*
        if #available(iOS 14.0, *) {
            GameCenter.shared.authPlayer(presentingVC: self)
        } else {
            GameCenter13.shared.authPlayer(presentingVC: self)

        }
        */
        GameCenter13.shared.authPlayer(presentingVC: self)
        //showLeaderboard()

    }
        
    override func viewWillAppear(_ animated: Bool) {
        
        
        /*
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { (status) in
                // your code
                
                let a = ATTrackingManager.trackingAuthorizationStatus
                print(a.rawValue)
                let adverts = Ads(vct: self)
                adverts.createBannerView()
            }
            // To know current status
            let a = ATTrackingManager.trackingAuthorizationStatus
            print(a.rawValue)
        } else {
            // Fallback on earlier versions
 */
            let adverts = Ads(vct: self)
            adverts.createBannerView()
        
    }
    
    @IBAction func modePressed(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "modes") as! ModeViewController
        root.changeView(fromvc: self, tovc: viewController, animation: UIView.AnimationOptions.transitionCrossDissolve, duration: 0.5)
    }
    
    @IBAction func playPressed(_ sender: Any) {
        //launch(withAnimation: true, andMode: .classic)
        var modeSelected = UserDefaults.standard.value(forKey: "defaultMode")
        modeSelected = Mode(rawValue: modeSelected as! String)!
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "game") as! GameViewController
        viewController.mode = modeSelected as? Mode
        root.animationForLoad(fromvc: self, tovc: viewController)
    }
    
    @IBAction func settingsPressed(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "settings") as! SettingsViewController
        root.changeView(fromvc: self, tovc: viewController, animation: .transitionCrossDissolve, duration: 0.5)
    }
    
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func leaderboardPressed(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "leaderboard") as! LeaderboardViewController
        root.changeView(fromvc: self, tovc: viewController, animation: UIView.AnimationOptions.transitionCrossDissolve, duration: 0.5)
    }
    
    @IBAction func charactersPressed(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "characters") as! CharactersViewController
     
        root.changeView(fromvc: self, tovc: viewController, animation: UIView.AnimationOptions.transitionCrossDissolve, duration: 0.5)
        
    }
    
    
    func initaliseDB(){
        if (UserDefaults.standard.value(forKey: "classicHighscore") == nil){
            UserDefaults.standard.set(0, forKey: "classicHighscore")
            UserDefaults.standard.set(0, forKey: "reverseHighscore")
            UserDefaults.standard.set(0, forKey: "arcadeHighscore")
            UserDefaults.standard.set(0, forKey: "dashHighscore")
            UserDefaults.standard.set("Circle", forKey: "character")
            UserDefaults.standard.set(Mode.classic.rawValue, forKey: "defaultMode")
            UserDefaults.standard.set(false, forKey: "powerup")
        }
        
        var characterArray = [(id: Int, name: String, barrier: Int, Progress: Int, unlockedDescription: String, lockedDescription: String)]()

        characterArray.append((id: 1, name: "Circle", barrier: 1, Progress: 1, unlockedDescription: "Unlocked!", lockedDescription: "Unlock by downloading Laser Run 2!"))
        characterArray.append((id: 2, name: "Dog", barrier: 1, Progress: 0, unlockedDescription: "Unlocked by playing classic mode", lockedDescription: "Unlock by playing classic mode"))
        characterArray.append((id: 3, name: "Tree", barrier: 1, Progress: 0, unlockedDescription: "Unlocked by playing reverse mode", lockedDescription: "Unlock by playing reverse mode"))
        characterArray.append((id: 4, name: "House", barrier: 1, Progress: 0, unlockedDescription: "Unlocked by playing arcade mode", lockedDescription: "Unlock by playing arcade mode"))
        characterArray.append((id: 5, name: "Car", barrier: 1, Progress: 0, unlockedDescription: "Unlocked by playing dash mode", lockedDescription: "Unlock by playing dash mode"))
        characterArray.append((id: 6, name: "Cat", barrier: 100, Progress: 0, unlockedDescription: "Unlocked by playing 100 classic games", lockedDescription: "Unlock by playing 100 classic games"))
        characterArray.append((id: 7, name: "Cloud", barrier: 100, Progress: 0, unlockedDescription: "Unlocked by playing 100 reverse games", lockedDescription: "Unlock by playing 100 reverse games"))
        characterArray.append((id: 8, name: "Fish", barrier: 100, Progress: 0, unlockedDescription: "Unlocked by playing 100 arcade games", lockedDescription: "Unlock by playing 100 arcade games"))
        characterArray.append((id: 9, name: "Cactus", barrier: 100, Progress: 0, unlockedDescription: "Unlocked by playing 100 dash games", lockedDescription: "Unlock by playing 100 dash games"))
        characterArray.append((id: 10, name: "Power", barrier: 200, Progress: 0, unlockedDescription: "Unlocked by achieving 200 in classic", lockedDescription: "Unlock by achieving 200 in classic"))
        characterArray.append((id: 11, name: "Trash", barrier: 200, Progress: 0, unlockedDescription: "Unlocked by achieving 200 in reverse", lockedDescription: "Unlock by achieving 200 in reverse"))
        characterArray.append((id: 12, name: "Octopus", barrier: 200, Progress: 0, unlockedDescription: "Unlocked by achieving 200 in arcade", lockedDescription: "Unlock by achieving 200 in arcade"))
        characterArray.append((id: 13, name: "Leaf", barrier: 200, Progress: 0, unlockedDescription: "Unlocked by achieving 200 in dash", lockedDescription: "Unlock by achieving 200 in dash"))
        characterArray.append((id: 14, name: "Boat", barrier: 10000, Progress: 0, unlockedDescription: "Unlocked with 10000 total classic score", lockedDescription: "Unlock with 10000 total classic score"))
        characterArray.append((id: 15, name: "Bike", barrier: 10000, Progress: 0, unlockedDescription: "Unlocked with 10000 total reverse score", lockedDescription: "Unlock with 10000 total reverse score"))
        characterArray.append((id: 16, name: "Skyscraper", barrier: 10000, Progress: 0, unlockedDescription: "Unlocked with 10000 total arcade score", lockedDescription: "Unlock with 10000 total arcade score"))
        characterArray.append((id: 17, name: "Plane", barrier: 10000, Progress: 0, unlockedDescription: "Unlocked with 10000 total dash score", lockedDescription: "Unlock with 10000 total dash score"))
        

        let db = DBHelper()
        for element in characterArray{
            db.insert(id: element.id, name: element.name, barrier: element.barrier, progress: element.Progress, unlocked: element.unlockedDescription, locked: element.lockedDescription)
        }
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner Ad Loaded Successfully")
        bannerView.isHidden = false
    }

    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("Banner Ad Failed to Load: \(error.localizedDescription)")
        bannerView.isHidden = true
    }

    
    func gameCenterViewControllerDidFinish(gcViewController: GKGameCenterViewController!)
    {
        self.dismiss(animated: true, completion: nil)
    }
   

}
