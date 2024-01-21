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
        self.vc = vct
        bannerView = GADBannerView()
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = ProcessInfo.processInfo.environment["bannerId"]
        bannerView.adSize = GADAdSizeBanner
        bannerView.rootViewController = vc
    }
    
    func createBannerView(){
        if !AdService.shared.removedAds{
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
