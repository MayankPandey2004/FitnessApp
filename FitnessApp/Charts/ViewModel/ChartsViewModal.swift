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

    @Published var oneWeekAverage = 1243
    @Published var oneWeekTotal = 8223
    
    @Published var mockOneMonthData =
    [DailyStepModel]()
    @Published var oneMonthAverage = 3453
    @Published var oneMonthTotal = 3544
    
    @Published var mockThreeMonthData = [DailyStepModel]()
    @Published var threeMonthAverage = 43543
    @Published var threeMonthTotal = 34534
    
    @Published var ytdAverage = 34534
    @Published var ytdTotal = 43543
    
    @Published var oneYearAverage = 204443
    @Published var oneYearTotal = 200000
 
    init() {
        let mockOneMonth = self.mockDataForDays(days: 30)
        let mockThreeMonths  = self.mockDataForDays(days: 90)
        DispatchQueue.main.async {
            self.mockThreeMonthData = mockThreeMonths
            self.mockOneMonthData = mockOneMonth
        }
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
}
