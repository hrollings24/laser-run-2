//
//  ModeViewController.swift
//  Laser Run 2
//
//  Created by Harry Rollings on 30/06/2020.
//

import UIKit

class ModeViewController: UIViewController {
    
    @IBOutlet weak var logo: UILabel!
    @IBOutlet weak var classic: UIButton!
    @IBOutlet weak var reverse: UIButton!
    @IBOutlet weak var arcade: UIButton!
    @IBOutlet weak var dash: UIButton!
    @IBOutlet weak var back: UIButton!
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        view.isOpaque = false

        let adverts = Ads(vct: self)
        adverts.createBannerView()
        
        //Set text properties
        logo.font = UIFont(name: "Potra", size: FontSizer.init().setCustomFont(baseFont: 64))
        
        let fontsize = FontSizer.init().setCustomFont(baseFont: 46)
        classic.titleLabel?.font = UIFont(name: "Potra", size: fontsize)
        reverse.titleLabel?.font = UIFont(name: "Potra", size: fontsize)
        arcade.titleLabel?.font = UIFont(name: "Potra", size: fontsize)
        dash.titleLabel?.font = UIFont(name: "Potra", size: fontsize)
    }
    
    
    @IBAction func backPressed(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "menu") as! MenuViewController
              
        root.changeView(fromvc: self, tovc: viewController, animation: UIView.AnimationOptions.transitionCrossDissolve, duration: 0.5)
    }
    
    @IBAction func classicPressed(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "game") as! GameViewController
        viewController.mode = .classic
        root.animationForLoad(fromvc: self, tovc: viewController)
    }
    
    @IBAction func reversePressed(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "game") as! GameViewController
        viewController.mode = .reverse
        root.animationForLoad(fromvc: self, tovc: viewController)
    }
    
    @IBAction func arcadePressed(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "game") as! GameViewController
        viewController.mode = .arcade
        root.animationForLoad(fromvc: self, tovc: viewController)
    }
    
    @IBAction func dashPressed(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "game") as! GameViewController
        viewController.mode = .dash
        root.animationForLoad(fromvc: self, tovc: viewController)
    }
    
}
