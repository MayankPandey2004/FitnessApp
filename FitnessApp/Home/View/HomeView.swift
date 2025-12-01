import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @Binding var isPremium: Bool
    @State var showPayWall = false

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {

                    HStack {
                        Text("Welcome")
                        .font(.system(size: 34, weight: .bold))
                        .padding(.leading, 4)

                        Spacer()

                        if !isPremium {
                            Button {
                                showPayWall = true
                            } label: {
                                Text("Get Premium")
                                    .font(.callout)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .foregroundColor(.white)
                                    .background(Color.blue)
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)

                    HStack {
                        Spacer()
                        
                        VStack(alignment: .leading){
                            VStack (alignment: .leading, spacing: 8) {
                                Text("Calories")
                                    .font(.callout)
                                    .bold()
                                    .foregroundColor(.red)
                                Text("\(viewModel.calories)")
                                    .bold()
                            }
                            .padding(.bottom)
                            
                            VStack (alignment: .leading, spacing: 8) {
                                Text("Active")
                                    .font(.callout)
                                    .bold()
                                    .foregroundColor(.green)
                                Text("\(viewModel.exercise)")
                                    .bold()
                            }
                            .padding(.bottom)
                            
                            VStack (alignment: .leading, spacing: 8) {
                                Text("Stand")
                                    .font(.callout)
                                    .bold()
                                    .foregroundColor(.blue)
                                Text("\(viewModel.stand)")
                                    .bold()
                            }
                        }
                        
                        Spacer()
                        
                        ZStack {
                            ProgressCircleView(progress: $viewModel.calories, goal: 600, color: .red)
                            
                            ProgressCircleView(progress: $viewModel.exercise, goal: 60, color: .green)
                                .padding(.all, 20)
                            
                            ProgressCircleView(progress: $viewModel.stand, goal: 12, color: .blue)
                                .padding(.all, 40)
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    .padding()
                    
                   
                    Text("Fitness Activity")
                    .font(.system(size: 22, weight: .semibold))
                    .padding()
                    
                    if !viewModel.activities.isEmpty {
                        LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)) {
                            ForEach(viewModel.activities.prefix(isPremium == true ? 8 : 4), id: \.title) { activity in
                                ActivityCard(activity: activity)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                
                    Text("Recent Workouts")
                    .font(.system(size: 22, weight: .semibold))
                    .padding()
                    
                    LazyVStack {
                        ForEach(viewModel.workouts.prefix(isPremium == true ? 8 : 4), id: \.id) { workout in
                            WorkoutCard(workout: workout)
                        }
                    }
                }
                .onAppear {
                    viewModel.fetchRecentWorkouts()
                    viewModel.refreshAll()
                }
            }
        }
        .sheet(isPresented: $showPayWall) {
            PaywallView(isPremium: $isPremium)
        }
    }
}

#Preview {
    HomeView(isPremium: .constant(false))
}
