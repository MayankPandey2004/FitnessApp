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
    
    let database = Firestore.firestore()
    let weeklyLeaderboard: String = "\(Date().mondayDateFormat())-leaderboard"
    
    func fetchLeaderBoard() async throws {
        let snapshot = try await database.collection(weeklyLeaderboard).getDocuments()
//        print(snapshot.documents)
//        print(snapshot.documents.first?.data())
    }
    
    func postStepCountUpdateFor(username: String, count: Int) async throws {
        let leader = LeaderboardUser(username: username, count: count)
        let data = try Firestore.Encoder().encode(leader)
        try await database.collection(weeklyLeaderboard).document(username).setData(data, merge: false)
    }
}
