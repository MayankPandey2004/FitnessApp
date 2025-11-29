//
//  LeaderboardViewModel.swift
//  FitnessApp
//
//  Created by Mayank Pandey on 30/11/25.
//

import SwiftUI
import Combine

class LeaderboardViewModel: ObservableObject {
    
    @Published var leaders = [LeaderboardUser]()
    
    @Published var mockData = [
        LeaderboardUser(username: "jason", count: 4124),
        LeaderboardUser(username: "mayank", count: 3890),
        LeaderboardUser(username: "alex", count: 3651),
        LeaderboardUser(username: "sophia", count: 3547),
        LeaderboardUser(username: "rahul", count: 3398),
        LeaderboardUser(username: "emma", count: 3312),
        LeaderboardUser(username: "liam", count: 3230),
        LeaderboardUser(username: "ananya", count: 3158),
        LeaderboardUser(username: "daniel", count: 2987),
        LeaderboardUser(username: "olivia", count: 2841),
        LeaderboardUser(username: "katie", count: 2795)
    ]
    
    init() {
        Task {
            do {
                try await postStepCountUpdateForUser(username: "xcode", count: 123)
                let result = try await fetchLeaderboards()
                DispatchQueue.main.async {
                    self.leaders = result.top10
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    struct LeaderboardResults {
        let top10: [LeaderboardUser]
        let user: LeaderboardUser?
    }
    
    func fetchLeaderboards() async throws -> LeaderboardResults {
        let leaders = try await DatabaseManager.shared.fetchLeaderBoard()
        let top10 = Array(leaders.sorted(by: {$0.count > $1.count }).prefix(10))
        let username = UserDefaults.standard.string(forKey: "username")
        
        if let username = username{
            let user = leaders.first(where: {$0.username == username})
            return LeaderboardResults(top10: top10, user: user)
        } else {
            return LeaderboardResults(top10: top10, user: nil)
        }
    }
    
    func postStepCountUpdateForUser(username: String, count: Int) async throws {
        try await DatabaseManager.shared.postStepCountUpdateForUser(leader: LeaderboardUser(username: username, count: count))
    }
}
