//
//  GameCenter.swift
//  Laser Run
//
//  Created by Harry Rollings on 29/01/2020.
//  Copyright © 2020 Harry Rollings. All rights reserved.
//

import Foundation
import GameKit

enum GameCenterErrors: Error {
    case LeaderboardNotFound
    case ScoreNotUpdated
    
    public var localizedDescription: String {
        switch self {
        case .LeaderboardNotFound: return "There was a problem fetching the leaderboard"
        case .ScoreNotUpdated: return "Your score could not be added to Game Center"
        }
    }
}

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
    
   
    func getLeaderboard() async throws -> GKLeaderboard? {
        let leaderboardID = ["overallhighscores"]
        let leaderboards = try await GKLeaderboard.loadLeaderboards(IDs: leaderboardID)
        return leaderboards.first
    }

    
    
    func reportToLeaderboard(withScore: Int) async throws {
        guard let leaderboard = try await getLeaderboard() else {
            throw GameCenterErrors.LeaderboardNotFound
        }

        do {
            try await leaderboard.submitScore(withScore, context: 0, player: GKLocalPlayer.local)
        } catch {
            throw GameCenterErrors.ScoreNotUpdated
        }
    }

}
