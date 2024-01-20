//
//  SettingsViewController.swift
//  Laser Run 2
//
//  Created by Harry Rollings on 10/07/2020.
//

import UIKit
import StoreKit

class SettingsViewController: UIViewController, SKPaymentTransactionObserver, SKProductsRequestDelegate {

    @IBOutlet weak var remove: UIButton!
    @IBOutlet weak var setdefault: UIButton!
    
    @IBOutlet weak var collection: UIView!
    @IBOutlet weak var scroll: UIScrollView!
    
    @IBOutlet weak var credit: UILabel!
    @IBOutlet weak var overview: UIView!
    @IBOutlet weak var removeButton: UIButton!
    var adverts: Ads!
    @IBOutlet weak var restoreBtn: UIButton!
    @IBOutlet weak var logo: UILabel!
    
    var product: SKProduct?
    var productID = "modeflick.laser_run_2.removeads"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        SKPaymentQueue.default().add(self)

        addCredits()
        logo.font = UIFont(name: "Potra", size: FontSizer.init().setCustomFont(baseFont: 64))

        credit.font = UIFont(name: "Potra", size: FontSizer.init().setCustomFont(baseFont: 18))
        collection.isHidden = true
        overview.backgroundColor = .black
        overview.alpha = 0.0
        
        remove.backgroundColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
        setdefault.backgroundColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
        remove.titleLabel?.textColor = .black
        setdefault.titleLabel?.textColor = .black
        remove.layer.cornerRadius = 10
        setdefault.layer.cornerRadius = 10
        restoreBtn.backgroundColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
        restoreBtn.titleLabel?.textColor = .black
        restoreBtn.layer.cornerRadius = 10
        
        if UserDefaults.standard.value(forKey: "removedAds") as! Bool{
            removeButton.isEnabled = false
            restoreBtn.isEnabled = false

        }

        adverts = Ads(vct: self)
        adverts.createBannerView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(tapped))
        overview.addGestureRecognizer(tapGesture)
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func tapped(sender: UITapGestureRecognizer){
            overview.alpha = 0.0
            collection.isHidden = true
    }
    
    @IBAction func restorePressed(_ sender: Any) {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
        
    }
    
    @IBAction func backPressed(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "menu") as! MenuViewController
        root.changeView(fromvc: self, tovc: viewController, animation: UIView.AnimationOptions.transitionCrossDissolve, duration: 0.5)
    }
    
    @IBAction func setDefaultPressed(_ sender: UIButton) {
        
        collection.isHidden = !collection.isHidden
        switch collection.isHidden {
        case true:
            overview.alpha = 0.0
        case false:
            overview.alpha = 0.5
        }
    }
    
    @IBAction func removeAdsPressed(_ sender: Any) {
        getPurchaseInfo()
    }
    
    func addCredits(){
        let creditArray = ["Airplane created by Freepik on Flaticon", "Cactus created by Freepik on Flaticon", "Car created by Freepik on Flaticon", "Circle created by Scott De Jonge on Flaticon", "Cloud created by Madebyoliver on Flaticon", "Dog created by Freepik on Flaticon", "Dead Fish created by Freepik on Flaticon", "Leaf created by Freepik on Flaticon", "Power created by Dave Gandy on Flaticon", "Skyscraper created by Madebyoliver on Flaticon", "Tree created by Freepik on Flaticon", "Octopus created by Freepik on Flaticon", "Shark created by Freepik on Flaticon", "Bike created by Freepik on Flaticon", "Trash created by Madebyoliver on Flaticon", "Boat created by Freepik on Flaticon", "Cat created by Freepik on Flaticon", "Settings Icon created by Freepik on Flaticon"]
        var yPos = CGFloat(0.0)
        for i in 0 ..< creditArray.count {
            let newLabel = UILabel()
            newLabel.font = UIFont.systemFont(ofSize: FontSizer.init().setCustomFont(baseFont: 14))
            newLabel.text = creditArray[i]
            newLabel.frame.size.width = scroll.frame.size.width
            newLabel.frame.size.height = scroll.frame.height / 18
            newLabel.adjustsFontSizeToFitWidth = true
            newLabel.textColor = .black
            yPos += newLabel.frame.size.height + 4
            newLabel.center.y = yPos

            scroll.addSubview(newLabel)
        }
        
        scroll.contentSize.height = yPos + 10
        
    }
    
    func getPurchaseInfo(){
        
        if SKPaymentQueue.canMakePayments(){
            let request = SKProductsRequest(productIdentifiers: NSSet(object: self.productID) as! Set<String>)
            request.delegate = self
            request.start()
        }
        else{
            //IN APP PURCHASES DISABLED
            //Create alert view
            createAlert(withTitle: "In-App Purchases Disabled", withDescription: "Please enable in-app purchases in your device settings.")
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        if (products.count == 0){
            createAlert(withTitle: "Product Not Found", withDescription: "Could not establish a connection")
        }
        else{
            product = products[0]
            createPurchaseAlert(withTitle: product!.localizedTitle, withDescription: product!.localizedDescription)
            removeButton.isEnabled = true
        }
        let invalids = response.invalidProductIdentifiers
        for product in invalids{
            print("Product not found \(product)")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions{
            switch transaction.transactionState {
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                removeButton.isEnabled = false
                adverts.bannerView.isHidden = true
                //ALERT PAYMENT COMPLETE
                UserDefaults.standard.setValue(true, forKey: "removedAds")
                UserDefaults.standard.synchronize()
                break
            case .failed:
                //FAILED
                break
            default:
                break
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        for transaction in queue.transactions {
            let t: SKPaymentTransaction = transaction
            let prodID = t.payment.productIdentifier as String
            switch prodID {
            case productID:
                restoreBtn.isEnabled = false
                adverts.bannerView.isHidden = true
                UserDefaults.standard.setValue(true, forKey: "removedAds")
                UserDefaults.standard.synchronize()
                createAlert(withTitle: "Restored", withDescription: "Your purchased was restored")
            default:
                print("iap not found")
            }
        }
    }
    
    
    func createAlert(withTitle: String, withDescription: String){
        let alertController = UIAlertController(title: withTitle, message: withDescription, preferredStyle: .alert)
        //We add buttons to the alert controller by creating UIAlertActions:
        let actionOk = UIAlertAction(title: "OK",
            style: .default,
            handler: nil) //You can use a block here to handle a press on this button

        alertController.addAction(actionOk)

        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func createPurchaseAlert(withTitle: String, withDescription: String){
        let alertController = UIAlertController(title: withTitle, message: withDescription, preferredStyle: .alert)
        //We add buttons to the alert controller by creating UIAlertActions:
        alertController.addAction(UIAlertAction(title: "Purchase", style: UIAlertAction.Style.default)
           { action -> Void in
            let payment = SKPayment(product: self.product!)
            SKPaymentQueue.default().add(payment)
           })

        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
           { action -> Void in
            
           })
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
