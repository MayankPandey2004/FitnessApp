//
//  HomeViewModel.swift
//  FitnessApp
//
//  Created by Mayank Pandey on 28/11/25.
//

import SwiftUI
import Combine
import HealthKit

class HomeViewModel: ObservableObject {
    let healthManager = HealthManager.shared
    
    @Published var calories: Int = 123
    @Published var exercise: Int = 52
    @Published var stand: Int = 8
    
    var mockActivities = [
        Activity(
            id: 0,
            title: "Today Steps",
            subtitle: "Goal 12,000",
            image: "figure.walk",
            tintColor: Color.green,
            amount: "9,812"
        ),
        Activity(
            id: 2,
            title: "Today",
            subtitle: "Goal 1,000",
            image: "figure.walk",
            tintColor: Color.red,
            amount: "812"
        ),
        Activity(
            id: 3,
            title: "Today Steps",
            subtitle: "Goal 12,000",
            image: "figure.walk",
            tintColor: Color.blue,
            amount: "9,812"
        ),
        Activity(
            id: 4,
            title: "Today Steps",
            subtitle: "Goal 50,000",
            image: "figure.run",
            tintColor: Color.purple,
            amount: "104,812"
        )
    ]
    
    var mockWorkouts = [
        Workout(id: 0, title: "Running", image: "figure.run", tintColor: Color.cyan, duration: "51 mins", date: "Aug 1", calories: "512 kcal"),
        Workout(id: 1, title: "Strength Training", image: "figure.run", tintColor: Color.red, duration: "51 mins", date: "Aug 1", calories: "512 kcal"),
        Workout(id: 2, title: "Walk", image: "figure.walk", tintColor: Color.purple, duration: "5 mins", date: "Aug 11", calories: "512 kcal"),
        Workout(id: 3, title: "Running", image: "figure.run", tintColor: Color.cyan, duration: "1 mins", date: "Aug 19", calories: "512 kcal")
    ]
    
    init() {
        Task {
            do {
                try await healthManager.requestHealthKitAccess()
                fetchTodayCalories()
                fetchTodayExerciseTime()
                fetchTodayStandHours()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchTodayCalories() {
        healthManager.fetchTodayCaloriesBurned { result in
            switch result {
            case .success(let calories):
                DispatchQueue.main.async {
                    self.calories = Int(calories)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func fetchTodayExerciseTime() {
        healthManager.fetchTodayExerciseTime { result in
            switch result {
            case .success(let exercise):
                DispatchQueue.main.async {
                    self.exercise = Int(exercise)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func fetchTodayStandHours() {
        healthManager.fetchTodayStandHours { result in
            switch result {
            case .success(let hours):
                DispatchQueue.main.async {
                    self.stand = hours
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}
