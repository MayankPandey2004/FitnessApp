//
//  HealthManager.swift
//  FitnessApp
//
//  Created by Mayank Pandey on 28/11/25.
//

import SwiftUI
import Foundation
import HealthKit

class HealthManager {
    
    static let shared = HealthManager()
    let healthStore = HKHealthStore()
    
    private init() {
        Task {
            do {
                try await requestHealthKitAccess()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func requestHealthKitAccess() async throws {
        let calories = HKQuantityType(.activeEnergyBurned)
        let exercise = HKQuantityType(.appleExerciseTime)
        let stand = HKCategoryType(.appleStandHour)
        let steps = HKQuantityType(.stepCount)
        let workouts = HKSampleType.workoutType()
        
        let healthTypes: Set = [calories, exercise, stand, steps, workouts]
        try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
    }
    
    func fetchTodayCaloriesBurned(completion: @escaping (Result<Double, Error>) -> ()) {
        let caloriesType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        
        let predicate = HKQuery.predicateForSamples(
            withStart: .startOfDay,
            end: Date(),
            options: .strictStartDate
        )

        let query = HKStatisticsQuery(
            quantityType: caloriesType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, results, error in
            
            guard let quantity = results?.sumQuantity(), error == nil else {
                completion(.failure(error ?? URLError(.badURL)))
                return
            }
            
            let kcal = quantity.doubleValue(for: .kilocalorie())
            completion(.success(kcal))
        }

        healthStore.execute(query)
    }

    
    func fetchTodayExerciseTime(completion: @escaping (Result<Double, Error>) -> ()) {

        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)

        let type = HKQuantityType(.appleExerciseTime)

        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: now,
            options: .strictStartDate
        )

        let query = HKStatisticsQuery(
            quantityType: type,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, results, error in

            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
                return
            }

            guard let quantity = results?.sumQuantity() else {
                completion(.success(0))
                return
            }

            let minutes = quantity.doubleValue(for: .minute())
            completion(.success(minutes))
        }

        healthStore.execute(query)
    }

    
    func fetchTodayStandHours(completion: @escaping (Result<Int, Error>) -> ()) {
        let stand = HKCategoryType(.appleStandHour)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKSampleQuery(sampleType: stand, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, results, error in
            guard let samples = results as? [HKCategorySample], error == nil else {
                completion(.failure(URLError(.badURL)))
                return
            }
            print(samples)
            print(samples.map({ $0.value}))
            let standCount = samples.filter({$0.value == 0}).count
            completion(.success(standCount))
        }
        
        healthStore.execute(query)
    }
    
    // MARK: Fitness Activity
    func fetchTodaySteps(completion: @escaping (Result<Activity, Error>) -> ()) {
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, results, error in
            
            guard let quantity = results?.sumQuantity(), error == nil else {
                completion(.failure(URLError(.badURL)))
                return
            }
            
            let steps = quantity.doubleValue(for: .count())
            let activity = Activity(title: "Today Steps", subtitle: "Goal: 800", image: "figure.walk", tintColor: .green, amount: steps.formattedNumberString())
            completion(.success(activity))
        }
        
        healthStore.execute(query)
    }
    
    func fetchCurrentWeakWorkoutStats(completion: @escaping (Result<[Activity], Error>) -> Void) {
        let workout = HKObjectType.workoutType()
        let predicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
        let query = HKSampleQuery(sampleType: workout, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { [weak self] _, results, error in
            guard let workouts = results as? [HKWorkout], let self = self, error == nil else {
                completion(.failure(URLError(.badURL)))
                return
            } 
            
            var runningCount: Int = 0
            var steppingCount: Int = 0
            var soccerCount: Int = 0
            var basketballCount: Int = 0
            var stairCount: Int = 0
            var kickboxingCount: Int = 0
            
            for workout in workouts {
                let duration = Int(workout.duration) / 60
                if workout.workoutActivityType == .running {
                    runningCount += duration
                } else if workout.workoutActivityType == .traditionalStrengthTraining {
                    steppingCount += duration
                } else if workout.workoutActivityType == .soccer {
                    soccerCount += duration
                } else if workout.workoutActivityType == .basketball {
                    basketballCount += duration
                } else if workout.workoutActivityType == .stairClimbing {
                    stairCount += duration
                } else if workout.workoutActivityType == .kickboxing {
                    kickboxingCount += duration
                }
            }
            
            completion(.success(self.generateActivitiesFromDurations(running: runningCount, strength: steppingCount, soccer: soccerCount, basketball: basketballCount, stairs: stairCount, kickboxing: kickboxingCount)))
        }
        healthStore.execute(query)
    }
    
    func generateActivitiesFromDurations(running: Int, strength: Int, soccer: Int, basketball: Int, stairs: Int, kickboxing: Int) -> [Activity] {
        return [
            Activity(title: "Running", subtitle: "This week", image: "figure.run", tintColor: .green, amount: "\(running) mins"),
            Activity(title: "Strength Training", subtitle: "This week", image: "dumbbell", tintColor: .green, amount: "\(strength) mins"),
            Activity(title: "Soccer", subtitle: "This week", image: "soccerball", tintColor: .green, amount: "\(soccer) mins"),
            Activity(title: "Basketball", subtitle: "This week", image: "basketball", tintColor: .green, amount: "\(basketball) mins"),
            Activity(title: "Stairstepper", subtitle: "This week", image: "stairs", tintColor: .green, amount: "\(stairs)"),
            Activity(title: "Kickboxing", subtitle: "This week", image: "figure.martial.arts", tintColor: .green, amount: "\(kickboxing) mins"),
        ]
    }
}

//MARK: ChartView Data
extension HealthManager {
    
    struct YearChartDataResult {
        let ytd: [MonthlyStepModel]
        let oneYear: [MonthlyStepModel]
    }
    
    func fetchDailySteps(startDate: Date, completion: @escaping (Result<[DailyStepModel], Error>) -> Void) {
        let stepsType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date())

        let query = HKStatisticsCollectionQuery(
            quantityType: stepsType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: startDate,
            intervalComponents: DateComponents(day: 1)
        )

        query.initialResultsHandler = { _, results, error in

            guard let statsCollection = results, error == nil else {
                completion(.failure(error ?? URLError(.badURL)))
                return
            }

            var dailyModels: [DailyStepModel] = []

            statsCollection.enumerateStatistics(from: startDate, to: Date()) { stats, _ in
                let count = stats.sumQuantity()?.doubleValue(for: .count()) ?? 0
                dailyModels.append(
                    DailyStepModel(date: stats.startDate, count: Int(count))
                )
            }

            completion(.success(dailyModels))
        }

        healthStore.execute(query)
    }

    
    func fetchYTDAndOneYearChartData(completion: @escaping (Result<YearChartDataResult, Error>) -> Void) {
        let steps = HKQuantityType(.stepCount)
        let calendar = Calendar.current
        
        var oneYearMonths: [MonthlyStepModel] = []
        var ytdMonths: [MonthlyStepModel] = []
        
        for i in 0...11 {
            let month = calendar.date(byAdding: .month, value: -1, to: Date()) ?? Date()
            let (startOfMonth, endOfMonth) = month.startAndEndOfMonth()
            let predicate = HKQuery.predicateForSamples(withStart: startOfMonth, end: endOfMonth)
            let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, results, error in
                
                guard let steps = results?.sumQuantity()?.doubleValue(for: .count()), error == nil else {
                    completion(.failure(URLError(.badURL)))
                    return
                }
                
                if i == 0 {
                    oneYearMonths.append(MonthlyStepModel(date: month, count: Int(steps)))
                    ytdMonths.append(MonthlyStepModel(date: month, count: Int(steps)))
                } else {
                    oneYearMonths.append(MonthlyStepModel(date: month, count: Int(steps)))
                    if calendar.component(.year, from: Date()) == calendar.component(.year, from: month) {
                        ytdMonths.append(MonthlyStepModel(date: month, count: Int(steps)))
                    }
                }
                
                if i == 11 {
                    completion(.success(YearChartDataResult(ytd: ytdMonths, oneYear: oneYearMonths)))
                }
            }
            healthStore.execute(query)
        }
    }
}

//MARK: Leaderboard View
extension HealthManager {
    
    func fetchCurrentWeekStepCount(completion: @escaping (Result<Double, Error>) -> Void) {
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, results, error in
            
            guard let quantity = results?.sumQuantity(), error == nil else {
                completion(.failure(URLError(.badURL)))
                return
            }
            
            let steps = quantity.doubleValue(for: .count())
            completion(.success(steps))
        }
        
        healthStore.execute(query)
    }
    
    func fetchWorkoutsForMonth(month: Date, completion: @escaping (Result<[Workout], Error>) -> Void) {

        let (startOfMonth, endOfMonth) = month.startAndEndOfMonth()

        let predicate = HKQuery.predicateForSamples(
            withStart: startOfMonth,
            end: endOfMonth,
            options: .strictStartDate
        )

        let workoutType = HKObjectType.workoutType()

        let query = HKSampleQuery(
            sampleType: workoutType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [
                NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            ]
        ) { _, results, error in

            guard let hkWorkouts = results as? [HKWorkout], error == nil else {
                completion(.failure(error ?? URLError(.badURL)))
                return
            }

            let mapped: [Workout] = hkWorkouts.map { hk in

                let durationMinutes = max(1, Int(hk.duration / 60))

                // Modern HK calories API
                let caloriesBurned = Int(
                    hk.statistics(for: HKQuantityType(.activeEnergyBurned))?
                        .sumQuantity()?
                        .doubleValue(for: .kilocalorie()) ?? 0
                )

                let dateFormatted = hk.startDate.formatted(date: .abbreviated, time: .shortened)

                return Workout(
                    id: hk.uuid.hashValue,
                    title: hk.workoutActivityType.displayName,
                    image: hk.workoutActivityType.sfSymbolName,
                    tintColor: .blue,
                    duration: "\(durationMinutes) mins",
                    date: dateFormatted,
                    calories: "\(caloriesBurned) kcal"
                )
            }

            completion(.success(mapped))
        }

        healthStore.execute(query)
    }
    
    func fetchAllWorkouts(completion: @escaping (Result<[Workout], Error>) -> Void) {

        let predicate = HKQuery.predicateForSamples(
            withStart: Date.distantPast,
            end: Date(),
            options: []
        )

        let workoutType = HKObjectType.workoutType()

        let query = HKSampleQuery(
            sampleType: workoutType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [
                NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            ]
        ) { _, results, error in
            
            guard let hkWorkouts = results as? [HKWorkout], error == nil else {
                completion(.failure(error ?? URLError(.badURL)))
                return
            }

            let mapped: [Workout] = hkWorkouts.map { hk in
                let durationMinutes = max(1, Int(hk.duration / 60))

                let caloriesBurned = Int(
                    hk.statistics(for: HKQuantityType(.activeEnergyBurned))?
                        .sumQuantity()?
                        .doubleValue(for: .kilocalorie()) ?? 0
                )

                return Workout(
                    id: hk.uuid.hashValue,
                    title: hk.workoutActivityType.displayName,
                    image: hk.workoutActivityType.sfSymbolName,
                    tintColor: .blue,
                    duration: "\(durationMinutes) mins",
                    date: hk.startDate.formatted(date: .abbreviated, time: .shortened),
                    calories: "\(caloriesBurned) kcal"
                )
            }

            let sorted = mapped.sorted { w1, w2 in
                let w1IsZero = (w1.duration == "0 mins" || w1.calories == "0 kcal")
                let w2IsZero = (w2.duration == "0 mins" || w2.calories == "0 kcal")

                if w1IsZero != w2IsZero {
                    return !w1IsZero
                }

                return true
            }

            completion(.success(sorted))
        }

        healthStore.execute(query)
    }
}
