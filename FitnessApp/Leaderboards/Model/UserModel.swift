//
//  UserModel.swift
//  FitnessApp
//
//  Created by Mayank Pandey on 08/12/25.
//

import Foundation

struct LeaderboardUser: Codable, Identifiable {
    var id = UUID()
    let username: String
    let count: Int
}
