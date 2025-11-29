//
//  DatabaseManager.swift
//  FitnessApp
//
//  Created by Mayank Pandey on 30/11/25.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreCombineSwift

class DatabaseManager {
    static let shared = DatabaseManager()
    private init() {}
    
    private let database = Firestore.firestore()
    let weeklyLeaderboard: String = "\(Date().mondayDateFormat())-leaderboard"
    
    func fetchLeaderBoard() async throws -> [LeaderboardUser] {
        let snapshot = try await database.collection(weeklyLeaderboard).getDocuments()
        return try snapshot.documents.compactMap({ try $0.data(as: LeaderboardUser.self )})
    }
    
    func postStepCountUpdateForUser(leader: LeaderboardUser) async throws {
        let data = try Firestore.Encoder().encode(leader)
        try await database.collection(weeklyLeaderboard).document(leader.username).setData(data, merge: false)
    }
}
