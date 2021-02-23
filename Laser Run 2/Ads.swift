//
//  Ads.swift
//  Laser Run 2
//
//  Created by Harry Rollings on 06/07/2020.
//

import Foundation
import UIKit
import GoogleMobileAds

class Ads{
    
    var vc: UIViewController!
    var bannerView: GADBannerView!
    
    init(vct: UIViewController){
        if UserDefaults.standard.value(forKey: "removedAds") == nil{
            UserDefaults.standard.setValue(false, forKey: "removedAds")
        }
        self.vc = vct
        bannerView = GADBannerView()
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = AdIDs.bannerID //Your Ad ID goes here
        bannerView.adSize = kGADAdSizeSmartBannerPortrait
        bannerView.rootViewController = vc
    }
    
    func createBannerView(){
        let value = UserDefaults.standard.value(forKey: "removedAds") as! Bool
        if !value{
            addBannerViewToView(bannerView)
            bannerView.load(GADRequest())
        }
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(bannerView)
        vc.view.addConstraints(
        [NSLayoutConstraint(item: bannerView,
                            attribute: .bottom,
                            relatedBy: .equal,
                            toItem: vc.view.safeAreaLayoutGuide,
                            attribute: .bottom,
                            multiplier: 1,
                            constant: 0),
         NSLayoutConstraint(item: bannerView,
                            attribute: .centerX,
                            relatedBy: .equal,
                            toItem: vc.view,
                            attribute: .centerX,
                            multiplier: 1,
                            constant: 0)
        ])
     }
}
