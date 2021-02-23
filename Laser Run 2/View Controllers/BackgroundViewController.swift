//
//  BackgroundViewController.swift
//  Laser Run 2
//
//  Created by Harry Rollings on 10/07/2020.
//

import UIKit

var theme: String!
var root: BackgroundViewController!

class BackgroundViewController: UIViewController {
    
    var container: UIView!
    var isInitialTheme: Bool!
    var backgroundImage: UIImageView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        root = self

        //Load the background image
        let frame = CGRect(x: 0, y: -UIScreen.main.bounds.width*10 + UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width*10)
        backgroundImage = UIImageView(frame: frame)
        isInitialTheme = true
        if isInitialTheme{
            let arrayOfThemes: [String] = ["theme1", "theme2", "theme3", "theme4"]
            theme = arrayOfThemes.randomElement()
        }
        backgroundImage.image = UIImage(named: theme)
        self.view.insertSubview(backgroundImage, at: 0)
        
        container = self.view
        
        let menuChild: MenuViewController!
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        menuChild = mainStoryboard.instantiateViewController(withIdentifier: "menu") as? MenuViewController
        addNewChild(viewController: menuChild)
        
    }
    
    func addNewChild(viewController: UIViewController){
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
        viewController.view.pinEdges(to: self.view)
    }
    
    func animationForLoad(fromvc: UIViewController, tovc: UIViewController) {

        self.addChild(tovc)
        self.container.addSubview(tovc.view)
        
        switch tovc {
        case is GameViewController:
            let tovc2 = tovc as! GameViewController
            tovc2.setCharacterStart()

            break
                
        default:
            break
        }
        
        let toImage = UIImage(named: theme)
         UIView.transition(with: self.backgroundImage,
                           duration: 0.5,
                           options: .transitionCrossDissolve,
                           animations: {
                               self.backgroundImage.image = toImage
                           },
                           completion: nil)
          
        self.transition(from: fromvc, to: tovc, duration: 0.5, options: UIView.AnimationOptions.beginFromCurrentState, animations: {
                
                switch fromvc {
                case is MenuViewController:
                    let fromvc2 = fromvc as! MenuViewController
                    fromvc2.logo.center = CGPoint(x: fromvc2.logo.center.x, y:  -50)
                    fromvc2.playBtn.center =  CGPoint(x: fromvc2.playBtn.center.x, y: fromvc2.view.frame.height + 50)
                    fromvc2.modesBtn.center =  CGPoint(x: fromvc2.playBtn.center.x, y: fromvc2.view.frame.height + 50)
                    fromvc2.leaderboardBtn.center =  CGPoint(x: fromvc2.playBtn.center.x, y: fromvc2.view.frame.height + 50)
                    fromvc2.storeBtn.center = CGPoint(x: fromvc2.playBtn.center.x, y: fromvc2.view.frame.height + 50)
                    fromvc2.settings.center = CGPoint(x: fromvc2.settings.center.x, y: -50)
                    let tovc2 = tovc as! GameViewController
                    tovc2.setCharacterEnd()
                    break
                    
                case is ModeViewController:
                    let fromvc2 = fromvc as! ModeViewController
                    fromvc2.logo.center = CGPoint(x: fromvc2.logo.center.x, y:  -50)
                    fromvc2.arcade.center =  CGPoint(x: fromvc2.arcade.center.x, y: fromvc2.view.frame.height + 50)
                    fromvc2.classic.center =  CGPoint(x: fromvc2.arcade.center.x, y: fromvc2.view.frame.height + 50)
                    fromvc2.reverse.center =  CGPoint(x: fromvc2.arcade.center.x, y: fromvc2.view.frame.height + 50)
                    fromvc2.dash.center = CGPoint(x: fromvc2.arcade.center.x, y: fromvc2.view.frame.height + 50)
                    fromvc2.back.center = CGPoint(x: fromvc2.back.center.x, y: -50)

                    let tovc2 = tovc as! GameViewController
                    tovc2.setCharacterEnd()
                    break
                case is EndViewController:
                    let fromvc2 = fromvc as! EndViewController
                    fromvc2.highscoreLB.center = CGPoint(x: fromvc2.highscoreLB.center.x, y:  -50)
                    fromvc2.replay.center =  CGPoint(x: fromvc2.replay.center.x, y: fromvc2.view.frame.height + 50)
                    fromvc2.menu.center =  CGPoint(x: fromvc2.menu.center.x, y: fromvc2.view.frame.height + 50)
                    fromvc2.share.center =  CGPoint(x: fromvc2.share.center.x, y: fromvc2.view.frame.height + 50)
                    fromvc2.scoreLB.center = CGPoint(x: fromvc2.scoreLB.center.x, y: -50)
                    fromvc2.scoreText.center = CGPoint(x: fromvc2.scoreText.center.x, y: -50)

                    let tovc2 = tovc as! GameViewController
                    tovc2.setCharacterEnd()
                    break
                        
                default:
                    //tovc.view.frame = fromvc.view.frame
                    //fromvc.view.frame.origin.x = endOriginx
                    break
                }
            
            
                }, completion: { (finish) in
                    
                    tovc.didMove(toParent: self)
                    fromvc.view.removeFromSuperview()
                    fromvc.removeFromParent()
                    
                    switch tovc {
                    case is GameViewController:
                        let tovc2 = tovc as! GameViewController
                        tovc2.loadScene()

                        break
                            
                    default:
                       break
                    }
                    
            })
        }
  
    func changeView(fromvc: UIViewController, tovc: UIViewController, animation: UIView.AnimationOptions, duration: TimeInterval){
        self.addChild(tovc)
        self.transition(from: fromvc, to: tovc, duration: duration, options: animation, animations: {
            self.container.addSubview(tovc.view)
        }, completion:{ (finish) in
            tovc.didMove(toParent: self)
            fromvc.view.removeFromSuperview()
            fromvc.removeFromParent()
            
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

enum Animation {
    case LeftToRight
    case RightToLeft
}

extension UIView {
    func pinEdges(to other: UIView) {
        leadingAnchor.constraint(equalTo: other.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: other.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: other.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: other.bottomAnchor).isActive = true
    }
}
