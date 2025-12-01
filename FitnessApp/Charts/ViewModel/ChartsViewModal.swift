//
//  ChartsViewModal.swift
//  FitnessApp
//
//  Created by Mayank Pandey on 29/11/25.
//

import Combine
import SwiftUI

class ChartsViewModel: ObservableObject {

    @Published var oneWeekChartData = [DailyStepModel]()
    @Published var oneWeekAverage = 0
    @Published var oneWeekTotal = 0
    
    @Published var oneMonthChartData = [DailyStepModel]()
    @Published var oneMonthAverage = 0
    @Published var oneMonthTotal = 0
    
    @Published var threeMonthChartData = [DailyStepModel]()
    @Published var threeMonthAverage = 0
    @Published var threeMonthTotal = 0
    
    @Published var ytdChartData = [MonthlyStepModel]()
    @Published var ytdAverage = 0
    @Published var ytdTotal = 0
    
    @Published var oneYearChartData = [MonthlyStepModel]()
    @Published var oneYearAverage = 0
    @Published var oneYearTotal = 0
    
    let healthManager = HealthManager.shared
 
    init() {
        fetchOneWeekStepData()
        fetchOneMonthStepData()
        fetchThreeMonthStepData()
        fetchYTDAndOneYearChartData()
    }
    
    func fetchOneWeekStepData() {
        healthManager.fetchDailySteps(startDate: .oneWeekAgo) { result in
            switch result {
            case .success(let steps):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.oneWeekChartData = steps
                    
                    (self.oneWeekTotal, self.oneWeekAverage) = self.calculateAverageAndTotalFromData(steps: steps)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func fetchOneMonthStepData() {
        healthManager.fetchDailySteps(startDate: .oneMonthAgo) { result in
            switch result {
            case .success(let steps):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.oneMonthChartData = steps
                    
                    (self.oneMonthTotal, self.oneMonthAverage) = self.calculateAverageAndTotalFromData(steps: steps)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func fetchThreeMonthStepData() {
        healthManager.fetchDailySteps(startDate: .threeMonthAgo) { result in
            switch result {
            case .success(let steps):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.threeMonthChartData = steps
                    
                    (self.threeMonthTotal, self.threeMonthAverage) = self.calculateAverageAndTotalFromData(steps: steps)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func fetchYTDAndOneYearChartData() {
        healthManager.fetchYTDAndOneYearChartData { result in
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    self.ytdChartData = result.ytd
                    self.oneYearChartData = result.oneYear
                    
                    self.ytdTotal = self.ytdChartData.reduce(0, { $0 + $1.count})
                    self.oneYearTotal = self.oneYearChartData.reduce(0, { $0 + $1.count})
                    
                    self.ytdAverage = self.ytdTotal / Calendar.current.component(.month, from: Date())
                    self.oneYearAverage = self.oneYearTotal / 12
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}

extension ChartsViewModel {
    func calculateAverageAndTotalFromData(steps: [DailyStepModel]) -> (Int, Int) {
        let total = steps.reduce(0) { $0 + Int($1.count) }
        let avg = steps.isEmpty ? 0 : total / steps.count
        return (total, avg)
    }
}
