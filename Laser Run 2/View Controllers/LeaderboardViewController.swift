//
//  LeaderboardViewController.swift
//  Laser Run 2
//
//  Created by Harry Rollings on 30/06/2020.
//

import UIKit
import GameKit

class LeaderboardViewController: UIViewController {
    
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var logo: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var activity: UIActivityIndicatorView!

    var scoresArray = [UIView]()
    
    @IBAction func scopeChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            removeScroll()
            getScores(limit: .global)
        case 1:
            removeScroll()
            getScores(limit: .friendsOnly)
        default:
            break
        }
    }
        
    func removeScroll(){
        let subviews = self.scrollView.subviews
        for subview in subviews{
            subview.removeFromSuperview()
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "menu") as! MenuViewController
       
        root.changeView(fromvc: self, tovc: viewController, animation: UIView.AnimationOptions.transitionCrossDissolve, duration: 0.5)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let adverts = Ads(vct: self)
        adverts.createBannerView()
        
        activity = UIActivityIndicatorView()
        activity.center = self.view.center
        activity.hidesWhenStopped = true
        activity.style = .gray
        self.view.addSubview(activity)
        
        view.backgroundColor = UIColor.clear
        view.isOpaque = false


        //Set text properties
        logo.font = UIFont(name: "Potra", size: FontSizer.init().setCustomFont(baseFont: 64))
        
        removeScroll()
        getScores(limit: .global)

    }
    
    func getScores(limit: GKLeaderboard.PlayerScope){
        
        activity.startAnimating()

        let leaderboard = GameCenter13.shared.getLeaderboard(withLimit: limit)

        leaderboard.loadScores { scores, error in
            guard let scores = scores else { return }
            var count = 0
            var array = [UIView]()
            outerloop: for score in scores {
                let nameLabel = UILabel()
                nameLabel.text = score.player.alias
                nameLabel.textColor = .white
                nameLabel.frame.size = CGSize(width: self.scrollView.frame.width/3*2, height: 40)
                nameLabel.adjustsFontSizeToFitWidth = true
                nameLabel.numberOfLines = 1
                nameLabel.font = UIFont.systemFont(ofSize: 32)
                let scoreLabel = UILabel()
                scoreLabel.text = String(score.value)
                scoreLabel.adjustsFontSizeToFitWidth = true
                scoreLabel.numberOfLines = 0
                scoreLabel.textColor = .white
                scoreLabel.font = UIFont.systemFont(ofSize: 32)
                scoreLabel.textAlignment = .right
                scoreLabel.frame.size = CGSize(width: self.scrollView.frame.width/3, height: 40)
                let newView = UIView()
                newView.backgroundColor = UIColor.red
                scoreLabel.frame.origin.x = self.scrollView.frame.width/3*2
                newView.sizeThatFits(CGSize(width: self.scrollView.frame.width, height: 40))
                newView.addSubview(nameLabel)
                //scoreLabel.translatesAutoresizingMaskIntoConstraints = false
                //scoreLabel.rightAnchor.constraint(equalTo: newView.rightAnchor, constant: -10).isActive = true
                newView.addSubview(scoreLabel)
                array.append(newView)
                if count < 10{
                    count += 1
                }
                else{
                    break outerloop
                }
            }
            self.addToScreen(limit: limit, array: array)
        }
    }
    
    //runs in background thread
    func addToScreen(limit: GKLeaderboard.PlayerScope, array: [UIView]) {
        var yPosition: CGFloat = 0.0
        
        activity.stopAnimating()
        for view in array{

            view.frame.origin.x = 0
            view.frame.origin.y = yPosition

            //add to scroll view
            self.scrollView.addSubview(view)
            
            yPosition += 50
        }
        
        self.scrollView.contentSize.height = yPosition
        
       
        scoresArray += array
        
        
    }

    

}
