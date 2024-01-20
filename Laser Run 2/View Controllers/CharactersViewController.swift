//
//  CharactersViewController.swift
//  Laser Run 2
//
//  Created by Harry Rollings on 30/06/2020.
//

import UIKit

class CharactersViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
 {

    @IBOutlet weak var logo: UILabel!
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = [Character]()
    var isLocked: Bool!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let adverts = Ads(vct: self)
        adverts.createBannerView()
        
        logo.font = UIFont(name: "Potra", size: FontSizer.init().setCustomFont(baseFont: 64))

        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        
        isLocked = false
        getCharacters(unlocked: !isLocked)
        
    }
    
    @IBAction func lockedChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            isLocked = false
            getCharacters(unlocked: !isLocked)
            collectionView.reloadData()
        case 1:
            isLocked = true
            getCharacters(unlocked: !isLocked)
            collectionView.reloadData()
        default:
            break
        }
    }
    
    @IBAction func back(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "menu") as! MenuViewController
       
        root.changeView(fromvc: self, tovc: viewController, animation: UIView.AnimationOptions.transitionCrossDissolve, duration: 0.5)
    }
    
    func getCharacters(unlocked: Bool){
        let dbhelper = DBHelper()
        var statement: String!
        if unlocked{
            statement = "SELECT * FROM character WHERE locked = 0"
        }
        else{
            statement = "SELECT * FROM character WHERE locked = 1"
        }
        items = dbhelper.read(queryStatementString: statement)
    }
       
   // MARK: - UICollectionViewDataSource protocol
   
   // tell the collection view how many cells to make
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return self.items.count
   }
   
   // make a cell for each cell index path
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionViewCell

        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        let characterInUse = self.items[indexPath.item]
        if isLocked{
            cell.des.text = characterInUse.lockedDescription
            cell.progressBar.isHidden = false
            let prog = Float(characterInUse.progress!)
            let bar = Float(characterInUse.barrier!)
            cell.progressBar.setProgress(prog/bar, animated: false)
        }
        else{
            let current = UserDefaults.standard.value(forKey: "character") as! String
            if current == characterInUse.imageNamed{
                cell.des.text = "Selected"
            }
            else{
                cell.des.text = characterInUse.unlockDescription
            }
            cell.des.adjustsFontSizeToFitWidth = true
            
            cell.progressBar.isHidden = true
        }
        let image = UIImage(named: characterInUse.imageNamed)
        cell.imageView.image = image
        cell.name = characterInUse.imageNamed
        cell.backgroundColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
        cell.layer.cornerRadius = 10

        return cell
   }
       
   // MARK: - UICollectionViewDelegate protocol
   
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        //get cell tapped on
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        if !isLocked{
            UserDefaults.standard.setValue(cell.name, forKey: "character")
            collectionView.reloadData()
        }
   }

}
