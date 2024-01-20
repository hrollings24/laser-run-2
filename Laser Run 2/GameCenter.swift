//
//  GameCenter.swift
//  Laser Run
//
//  Created by Harry Rollings on 29/01/2020.
//  Copyright © 2020 Harry Rollings. All rights reserved.
//

import Foundation
import GameKit


class GameCenter{
    
    static let shared = GameCenter()
    
    private init(){
        
    }
    
    func authPlayer(presentingVC: UIViewController){
        let localPlayer = GKLocalPlayer.local
        localPlayer.authenticateHandler = {
            (view, error) in
            
            if view != nil{
                presentingVC.present(view!, animated: true, completion: nil)
            }
            else{
                print(GKLocalPlayer.local.isAuthenticated)
            }
        }
    }
    
   
    func getLeaderboard() -> GKLeaderboard{
        var leader = GKLeaderboard()
        let leaderboardID = ["overallhighscores"]
        GKLeaderboard.loadLeaderboards(IDs: leaderboardID) { (leaderboards, error) in
            if error == nil{
                for leaderboard in leaderboards!{
                    leader = leaderboard
                }
            }
            else{
                print(error as Any)
            }
        }
        return leader
    }
    
    
    func reportToLeaderboard(withScore: Int){
        let leaderboard = getLeaderboard()
        leaderboard.submitScore(withScore, context: 0, player: GKLocalPlayer.local) { (error) in
            if error != nil{
                print(error as Any)
            }
            else{
                print("reported")
            }
        }
    }
    
    func getScores(withLimit: GKLeaderboard.PlayerScope){
        let leader = getLeaderboard()
        let range = NSMakeRange (1, 20);
        leader.loadEntries(for: withLimit, timeScope: .allTime, range: range) { (localPlayerEntry, entries, amountOfPlayers, error) in
            let scoreo = localPlayerEntry?.formattedScore
            print(scoreo as Any)
        }
    }
}
