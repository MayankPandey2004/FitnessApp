//
//  MonthlyStepModel.swift
//  FitnessApp
//
//  Created by Mayank Pandey on 29/11/25.
//

import Foundation
struct MonthlyStepModel: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}
