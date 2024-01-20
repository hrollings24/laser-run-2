//
//  SelectModeViewController.swift
//  Laser Run 2
//
//  Created by Harry Rollings on 13/07/2020.
//

import UIKit

class SelectModeViewController: UIViewController {

    @IBOutlet weak var classic: UIButton!
    @IBOutlet weak var arcade: UIButton!
    @IBOutlet weak var reverse: UIButton!
    @IBOutlet weak var dash: UIButton!
    
    @IBOutlet weak var selected: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 1)
        view.isOpaque = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true;
        selected.text = "Currently Selected: " + String(UserDefaults.standard.value(forKey: "defaultMode") as! String)

        classic.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.3)
        classic.layer.cornerRadius = 10
        reverse.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.3)
        reverse.layer.cornerRadius = 10
        arcade.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.3)
        arcade.layer.cornerRadius = 10
        dash.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.3)
        dash.layer.cornerRadius = 10


        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func classicPressed(_ sender: Any) {
        selected.text = "Currently Selected: Classic"
        UserDefaults.standard.setValue(Mode.classic.rawValue, forKey: "defaultMode")
    }
    
    @IBAction func arcadePressed(_ sender: Any) {
        selected.text = "Currently Selected: Arcade"
        UserDefaults.standard.setValue(Mode.arcade.rawValue, forKey: "defaultMode")

    }
    
    @IBAction func reversePressed(_ sender: Any) {
        selected.text = "Currently Selected: Reverse"
        UserDefaults.standard.setValue(Mode.reverse.rawValue, forKey: "defaultMode")

    }
    
    @IBAction func dashPressed(_ sender: Any) {
        selected.text = "Currently Selected: Dash"
        UserDefaults.standard.setValue(Mode.dash.rawValue, forKey: "defaultMode")

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
