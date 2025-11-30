//
//  LeaderboardViewModel.swift
//  FitnessApp
//
//  Created by Mayank Pandey on 30/11/25.
//

import SwiftUI
import Combine

class LeaderboardViewModel: ObservableObject {
    
    @Published var leaderResult = LeaderboardResults(top10: [], user: nil)
    
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
                try await setupLeaderboardData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func setupLeaderboardData() async throws {
        try await postStepCountUpdateForUser()
        let result = try await fetchLeaderboards()
        DispatchQueue.main.async {
            self.leaderResult = result
        }
    }
    
    struct LeaderboardResults {
        let top10: [LeaderboardUser]
        let user: LeaderboardUser?
    }
    
    private func fetchLeaderboards() async throws -> LeaderboardResults {
        let leaders = try await DatabaseManager.shared.fetchLeaderBoard()
        let top10 = Array(leaders.sorted(by: {$0.count > $1.count }).prefix(10))
        let username = UserDefaults.standard.string(forKey: "username")
        
        if let username = username, !top10.contains(where: {$0.username == username}){
            let user = leaders.first(where: {$0.username == username})
            return LeaderboardResults(top10: top10, user: user)
        } else {
            return LeaderboardResults(top10: top10, user: nil)
        }
    }
    
    private func postStepCountUpdateForUser() async throws {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            throw URLError(.badURL)
        }
        let steps = try await fetchCurrentWeekStepCount()
        try await DatabaseManager.shared.postStepCountUpdateForUser(leader: LeaderboardUser(username: username, count: Int(steps)))
    }
    
    private func fetchCurrentWeekStepCount() async throws -> Double {
        try await withCheckedThrowingContinuation({ continuation in
            HealthManager.shared.fetchCurrentWeekStepCount { result in
                continuation.resume(with: result)
                
            }
        })
    }
}
