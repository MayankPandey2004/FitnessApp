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
     
    @Published var calories: Int = 0
    @Published var exercise: Int = 0
    @Published var stand: Int = 0
    
    @Published var activities = [Activity]()
    @Published var workouts = [Workout]()
    
    init() {
        calories = 0
        exercise = 0
        stand = 0
        activities = []
        workouts = []

        Task {
            do {
                try await healthManager.requestHealthKitAccess()
                fetchTodayCalories()
                fetchTodayExerciseTime()
                fetchTodayStandHours()
                fetchTodaySteps()
                fetchCurrentWeekActivity()
                fetchRecentWorkouts()
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
                    let activity = Activity(title: "Calories Burned", subtitle: "today", image: "flame.fill", tintColor: .red, amount: calories.formattedNumberString())
                    self.activities.append(activity)
                }
            case .failure(let failure):
                DispatchQueue.main.async {
                    let activity = Activity(title: "Calories Burned", subtitle: "today", image: "flame.fill", tintColor: .red, amount: "---")
                    self.activities.append(activity)
                }
                print(failure.localizedDescription)
            }
        }
    }
    
    func fetchTodayExerciseTime() {
        healthManager.fetchTodayExerciseTime { result in
            switch result {
            case .success(let exerciseMinutes):
                DispatchQueue.main.async {
                    self.exercise = Int(exerciseMinutes)
                }
            case .failure(let error):
                print(error.localizedDescription)
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
    
    //MARK: Fitness Activity
    func fetchTodaySteps() {
        healthManager.fetchTodaySteps { result in
            switch result {
            case .success(let activity):
                DispatchQueue.main.async {
                    self.activities.append(activity)
                }
            case .failure:
                DispatchQueue.main.async {
                    self.activities.append(Activity(title: "Today Steps", subtitle: "Goal: 800", image: "figure.walk", tintColor: .green, amount: "---"))
                }
            }
        }
    }
    
    func fetchCurrentWeekActivity() {
        healthManager.fetchCurrentWeakWorkoutStats { result in
            switch result {
            case .success(let activities):
                DispatchQueue.main.async {
                    self.activities.append(contentsOf: activities)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func fetchRecentWorkouts() {
        healthManager.fetchAllWorkouts { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let workouts):
                DispatchQueue.main.async {
                    self.workouts = Array(workouts.prefix(4))
                }
            case .failure(let err):
                print("ERROR fetching workouts:", err.localizedDescription)
            }
        }
    }
    
    func refreshAll() {
        fetchTodayCalories()
        fetchTodayExerciseTime()
        fetchTodayStandHours()
        fetchTodaySteps()
        fetchCurrentWeekActivity()
        fetchRecentWorkouts()
    }
    
}
