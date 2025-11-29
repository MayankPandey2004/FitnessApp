//
//  ChartsViewModal.swift
//  FitnessApp
//
//  Created by Mayank Pandey on 29/11/25.
//

import Combine
import SwiftUI

class ChartsViewModel: ObservableObject {
    @Published var mockWeekChartData = [
        DailyStepModel(date: Date(), count: 12315),
        DailyStepModel(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, count: 9775),
        DailyStepModel(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, count: 9775),
        DailyStepModel(date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, count: 9775),
        DailyStepModel(date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!, count: 9775),
        DailyStepModel(date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, count: 9775),
        DailyStepModel(date: Calendar.current.date(byAdding: .day, value: -6, to: Date())!, count: 9775),
    ]
    
    @Published var mockYTDChartData = [
        DailyStepModel(date: Date(), count: 12315),
        DailyStepModel(date: Calendar.current.date(byAdding: .month, value: -1, to: Date())!, count: 9775),
        DailyStepModel(date: Calendar.current.date(byAdding: .month, value: -2, to: Date())!, count: 4533),
        DailyStepModel(date: Calendar.current.date(byAdding: .month, value: -3, to: Date())!, count: 45345),
        DailyStepModel(date: Calendar.current.date(byAdding: .month, value: -4, to: Date())!, count: 3422),
        DailyStepModel(date: Calendar.current.date(byAdding: .month, value: -5, to: Date())!, count: 32445),
        DailyStepModel(date: Calendar.current.date(byAdding: .month, value: -6, to: Date())!, count: 2344),
        DailyStepModel(date: Calendar.current.date(byAdding: .month, value: -7, to: Date())!, count: 9775),
        DailyStepModel(date: Calendar.current.date(byAdding: .month, value: -8, to: Date())!, count: 9775),
        DailyStepModel(date: Calendar.current.date(byAdding: .month, value: -9, to: Date())!, count: 9775)
    ]

    @Published var oneWeekAverage = 25455
    @Published var oneWeekTotal = 23456
    
    @Published var mockOneMonthData =
    [DailyStepModel]()
    @Published var oneMonthAverage = 6567
    @Published var oneMonthTotal = 7609
    
    @Published var mockThreeMonthData = [DailyStepModel]()
    @Published var threeMonthAverage = 8679
    @Published var threeMonthTotal = 8767
    
    @Published var ytdChartData = [MonthlyStepModel]()
    @Published var ytdAverage = 0
    @Published var ytdTotal = 0
    
    @Published var oneYearChartData = [MonthlyStepModel]()
    @Published var oneYearAverage = 0
    @Published var oneYearTotal = 0
    
    let healthManager = HealthManager.shared
 
    init() {
        let mockOneMonth = self.mockDataForDays(days: 30)
        let mockThreeMonths  = self.mockDataForDays(days: 90)
        DispatchQueue.main.async {
            self.mockThreeMonthData = mockThreeMonths
            self.mockOneMonthData = mockOneMonth
        }
        fetchYTDAndOneYearChartData()
    }
    
    func mockDataForDays(days: Int) -> [DailyStepModel] {
        var mockData = [DailyStepModel]()
        for day in 0..<days {
            let currentDate = Calendar.current.date(byAdding: .day, value: -day, to: Date())!
            let randomStepCount = Int.random(in: 500...15000)
            let dailyStepData = DailyStepModel(date: currentDate, count: randomStepCount)
            mockData.append(dailyStepData)
        }
        return mockData
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
