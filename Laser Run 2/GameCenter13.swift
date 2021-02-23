//
//  GameCenter13.swift
//  Laser Run 2
//
//  Created by Harry Rollings on 09/07/2020.
//

import Foundation
import GameKit

class GameCenter13{
    
    static let shared = GameCenter13()
    var rank: Int!
    
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
    
    func saveHighScore(numberToSave: Int){
        if GKLocalPlayer.local.isAuthenticated{
            let scoreReporter = GKScore(leaderboardIdentifier: "overallhighscores")
            scoreReporter.value = Int64(numberToSave)
            let scoreArray: [GKScore] = [scoreReporter]
            GKScore.report(scoreArray, withCompletionHandler: nil)
        }
    }
    
    func getHighScore() -> Int64{
        if GKLocalPlayer.local.isAuthenticated{
            let score = GKScore(leaderboardIdentifier: "overallhighscores", player: GKLocalPlayer.local)
            let scoreAsInt = score.value
            print("DIS SCORE")
            print(scoreAsInt)
            return scoreAsInt
        }
        else{
            print("not authenictated")
        }
        return 0
    }
    
    func getLeaderboard(withLimit: GKLeaderboard.PlayerScope) -> GKLeaderboard{
        let leaderboard = GKLeaderboard()
        leaderboard.playerScope = withLimit
        leaderboard.timeScope = .allTime
        leaderboard.identifier = "overallhighscores"
        return leaderboard
    }
    
    func getLeaderboardPosition(withLimit: GKLeaderboard.PlayerScope){
        let leader = getLeaderboard(withLimit: withLimit)
        
        leader.loadScores { (score, error) in
            if(error != nil){
                // Handle Error
            }else{
                if(score!.count > 0){
                    let score : GKScore = leader.localPlayerScore!
                    self.rank = score.rank
                }
            }
        }
    }
    
    func getFriendName(atRank: Int) -> String{
        var toReturn = ""
        let leader = getLeaderboard(withLimit: .friendsOnly)
        leader.loadScores { (score, error) in
            if(error != nil){
                // Handle Error
            }else{
                if(score!.count > 0){
                    for s in score!{
                        if s.rank == atRank{
                            toReturn = s.player.alias
                        }
                    }
                }
            }
        }
        return toReturn
    }
    
   
}
