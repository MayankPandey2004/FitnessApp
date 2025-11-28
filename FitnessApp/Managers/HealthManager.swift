//
//  HealthManager.swift
//  FitnessApp
//
//  Created by Mayank Pandey on 28/11/25.
//

import Foundation
import HealthKit

extension Date {
    static var startOfDay: Date {
        let  calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        return startOfDay
    }
}

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
        
        let healthTypes: Set = [calories, exercise, stand]
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
                completion(.failure(error ?? NSError()))
                return
            }
            
            let kcal = quantity.doubleValue(for: .kilocalorie())
            completion(.success(kcal))
        }

        healthStore.execute(query)
    }

    
    func fetchTodayExerciseTime(completion: @escaping (Result<Double, Error>) -> ()) {
        let exercise = HKQuantityType(.appleExerciseTime)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: exercise, quantitySamplePredicate: predicate) { _, results, error in
            
            guard let quantity = results?.sumQuantity(), error == nil else {
                completion(.failure(NSError()))
                return
            }
            
            let exerciseTime = quantity.doubleValue(for: .minute())
            completion(.success(exerciseTime))
        }
        
        healthStore.execute(query)
    }
    
    func fetchTodayStandHours(completion: @escaping (Result<Int, Error>) -> ()) {
        let stand = HKCategoryType(.appleStandHour)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKSampleQuery(sampleType: stand, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, results, error in
            guard let samples = results as? [HKCategorySample], error == nil else {
                completion(.failure(NSError()))
                return
            }
            print(samples)
            print(samples.map({ $0.value}))
            let standCount = samples.filter({$0.value == 0}).count
            completion(.success(standCount))
        }
        
        healthStore.execute(query)
    }
}
