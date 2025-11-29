//
//  DailyStepModel.swift
//  FitnessApp
//
//  Created by Mayank Pandey on 29/11/25.
//

import Foundation
struct DailyStepModel: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}
