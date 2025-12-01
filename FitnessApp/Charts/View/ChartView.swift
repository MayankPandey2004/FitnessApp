import SwiftUI
import Charts
import Combine


struct ChartsView: View {
    @StateObject var viewModel = ChartsViewModel()
    @State var selectedChart: ChartsOptions = .oneWeek
    var body: some View {
        VStack {
            Text("Charts")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()

            ZStack {
                switch selectedChart {
                case .oneWeek:
                    VStack {
                        ChartDataView(average: viewModel.oneWeekAverage, total: viewModel.oneWeekTotal)
                        Chart {
                            ForEach(viewModel.oneWeekChartData) { data in
                                BarMark(
                                    x: .value("Date", data.date, unit: .day),
                                    y: .value("Steps", data.count)
                                )
                            }
                        }
                    }

                case .oneMonth:
                    VStack {
                        ChartDataView(average: viewModel.oneMonthAverage, total: viewModel.oneMonthTotal)
                        Chart {
                            ForEach(viewModel.oneMonthChartData) { data in
                                BarMark(
                                    x: .value("Date", data.date, unit: .day),
                                    y: .value("Steps", data.count)
                                )
                            }
                        }
                    }

                case .threeMonth:
                    VStack {
                        ChartDataView(average: viewModel.threeMonthAverage, total: viewModel.threeMonthTotal)
                        Chart {
                            ForEach(viewModel.threeMonthChartData) { data in
                                LineMark(
                                    x: .value("Date", data.date, unit: .day),
                                    y: .value("Steps", data.count)
                                )
                            }
                        }
                    }

                case .yearToDate:
                    VStack {
                        ChartDataView(average: viewModel.ytdAverage, total: viewModel.ytdTotal)
                        Chart {
                            ForEach(viewModel.ytdChartData) { data in
                                BarMark(
                                    x: .value("Date", data.date, unit: .month),
                                    y: .value("Steps", data.count)
                                )
                            }
                        }
                    }

                case .oneYear:
                    VStack {
                        ChartDataView(average: viewModel.oneYearAverage, total: viewModel.oneYearTotal)
                        Chart {
                            ForEach(viewModel.oneYearChartData) { data in
                                BarMark(
                                    x: .value("Date", data.date, unit: .month),
                                    y: .value("Steps", data.count)
                                )
                            }
                        }
                    }
                }
            }
            .foregroundColor(.green)
            .frame(maxHeight: 450)
            .padding(.horizontal)

            HStack {
                ForEach(ChartsOptions.allCases, id: \.rawValue) { option in
                    Button(option.rawValue) {
                        withAnimation {
                            selectedChart = option
                        }
                    }
                    .padding()
                    .background(selectedChart == option ? .green : .clear)
                    .foregroundColor(selectedChart == option ? .white : .green)
                    .cornerRadius(10)
                }
            }
            .padding(.top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    ChartsView()
}
