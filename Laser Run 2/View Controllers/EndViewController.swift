//
//  EndViewController.swift
//  Laser Run 2
//
//  Created by Harry Rollings on 29/06/2020.
//

import UIKit

class EndViewController: UIViewController {

    @IBOutlet weak var scoreText: UILabel!
    
    @IBOutlet weak var scoreLB: UILabel!
    @IBOutlet weak var message: UILabel!
    
    @IBOutlet weak var replay: UIButton!
    @IBOutlet weak var menu: UIButton!
    @IBOutlet weak var share: UIButton!
    
    var mode: Mode!
    var score: Int!
    
    var charactersUnlocked = [String]()
    
    @IBAction func sharePressed(_ sender: Any) {
        let textToShare = "I just scored " + String(score) + " on Laser Run 2! Download on the App Store now."

        let objectsToShare = [textToShare]
        let activityVC = UIActivityViewController(activityItems: objectsToShare as [Any], applicationActivities: nil)

        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]

        activityVC.popoverPresentationController?.sourceView = self.view
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityVC.popoverPresentationController?.sourceRect = (sender.self as AnyObject).accessibilityFrame
        }
        self.present(activityVC, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var highscoreLB: UILabel!
    var highscore_achs_dic = [Mode: String]()
    var gamesplayed_achs_dic = [Mode: String]()
    var totalscore_achs_dic = [Mode: String]()
    
    @IBAction func replayPressed(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "game") as! GameViewController
        viewController.mode = mode
        root.animationForLoad(fromvc: self, tovc: viewController)
        
    }
    
    @IBAction func menuPressed(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "menu") as! MenuViewController
       
        root.changeView(fromvc: self, tovc: viewController, animation: UIView.AnimationOptions.transitionCrossDissolve, duration: 0.5)

    }
    
    func updateStats(){
        
        let db = DBHelper()
        let key = mode.rawValue + "Highscore"
        
        if score > 0{
            if score > (UserDefaults.standard.value(forKey: key) as! Int){
                //NEW HIGHSCORE
                UserDefaults.standard.set(score, forKey: key)
                let scoreAsString = String(score)
                let val = highscore_achs_dic[mode]!
                let characterList: [Character] = db.read(queryStatementString: "SELECT * FROM character WHERE \(val);")
                db.update(updateStatementString: "UPDATE character SET progress = \(scoreAsString) WHERE \(val);")
                for character in characterList{
                    let idAsString = "id IN ( " + String(character.id) + ")"
                    if score >= character.barrier && character.locked{
                        //achievement now unlocked
                        db.update(updateStatementString: "UPDATE character SET locked = 0 WHERE \(idAsString);")
                        charactersUnlocked.append(character.imageNamed)
                    }
                }
                
            }
            var val2 = gamesplayed_achs_dic[mode]!
            var characterList: [Character] = db.read(queryStatementString: "SELECT * FROM character WHERE \(val2);")
            updateWithList(characterList: characterList, db: db, progressIncrementer: 1)
            val2 = totalscore_achs_dic[mode]!
            characterList = db.read(queryStatementString: "SELECT * FROM character WHERE \(val2);")
            updateWithList(characterList: characterList, db: db, progressIncrementer: Int32(score))
        }
        highscoreLB.text = NSString(format: "HIGHSCORE: %i", UserDefaults.standard.value(forKey: key) as! Int) as String
    }
        
    func updateWithList(characterList: [Character], db: DBHelper, progressIncrementer: Int32){
        for character in characterList{
            let prog: Int32 = character.progress + progressIncrementer
            let idAsString = String(character.id)
            db.update(updateStatementString: "UPDATE character SET progress = \(prog) WHERE id = \(idAsString);")
            if prog >= character.barrier && character.locked{
                //achievement now unlocked
                db.update(updateStatementString: "UPDATE character SET locked = 0 WHERE id = \(idAsString);")
                charactersUnlocked.append(character.imageNamed)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let adverts = Ads(vct: self)
        adverts.createBannerView()

        view.backgroundColor = UIColor.clear
        view.isOpaque = false

        
        //Set font sizes
        let fontsize = FontSizer.init().setCustomFont(baseFont: 46)
        replay.titleLabel?.font = UIFont(name: "Potra", size: fontsize)
        menu.titleLabel?.font = UIFont(name: "Potra", size: fontsize)
        share.titleLabel?.font = UIFont(name: "Potra", size: fontsize)
        highscoreLB?.font = UIFont(name: "Potra", size: FontSizer.init().setCustomFont(baseFont: 36))

        scoreLB.font = UIFont(name: "Potra", size: fontsize)
        scoreText.font = UIFont(name: "Potra", size: FontSizer.init().setCustomFont(baseFont: 64))
        
        //Update score
        scoreLB.text = "\(score!)"
        
        
        let key = mode.rawValue + "Highscore"
        highscoreLB.text = NSString(format: "HIGHSCORE: %i", UserDefaults.standard.value(forKey: key) as! Int) as String
        
        highscore_achs_dic = [.classic:"id IN (10)", .reverse:"id IN (11)", .arcade:"id IN (12)", .dash:"id IN (13)"]
        gamesplayed_achs_dic = [.classic:"id IN (2,6)", .reverse:"id IN (3,7)", .arcade:"id IN (4,8)", .dash:"id IN (5,9)"]
        totalscore_achs_dic = [.classic:"id IN (14)", .reverse:"id IN (15)", .arcade:"id IN (16)", .dash:"id IN (17)"]

        
        updateStats()
            
        /*
        if #available(iOS 14.0, *) {
            // use the feature only available in iOS 14
            GameCenter.shared.reportToLeaderboard(withScore: self.score)
        }
        else {
            // pre iOS 14
        */
        GameCenter13.shared.saveHighScore(numberToSave: self.score)
        
        //create message AFTER stats updated
        message.text = checkAchievements()

    }
    
    func checkAchievements() -> String{
        if charactersUnlocked.count == 1{
            return "You just unlocked the " + charactersUnlocked[0] + "!"
        }
        else if charactersUnlocked.count > 1{
            return "You just unlocked multiple characters!"
        }
        else{
            return ""
        }
    }
}
