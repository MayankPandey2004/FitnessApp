//
//  LeaderboardViewModel.swift
//  FitnessApp
//
//  Created by Mayank Pandey on 30/11/25.
//

import SwiftUI
import Combine

class LeaderboardViewModel: ObservableObject {
    
    @Published var leaderResult = LeaderboardResults(top10: [], user: nil, rank: nil)
    
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
    
    private func fetchLeaderboards() async throws -> LeaderboardResults {
        let leaders = try await DatabaseManager.shared.fetchLeaderBoard()

        let sorted = leaders.sorted(by: { $0.count > $1.count })
        let top10 = Array(sorted.prefix(10))

        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return LeaderboardResults(top10: top10, user: nil, rank: nil)
        }
        
        if let index = sorted.firstIndex(where: { $0.username == username }) {
            let user = sorted[index]
            let rank = index + 1

            return LeaderboardResults(top10: top10, user: user, rank: rank)
        } else {
            return LeaderboardResults(top10: top10, user: nil, rank: nil)
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
