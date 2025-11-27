//
//  HomeView.swift
//  FitnessApp
//
//  Created by Mayank Pandey on 27/11/25.
//

import SwiftUI

struct HomeView: View {
    @State var calories: Int = 123
    @State var active: Int = 52
    @State var stand: Int = 8
    
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
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text("Welcome")
                        .font(.largeTitle)
                        .padding()
                    
                    HStack {
                        
                        Spacer()
                        
                        VStack{
                            VStack (alignment: .leading, spacing: 8) {
                                Text("Calories")
                                    .font(.callout)
                                    .bold()
                                    .foregroundColor(.red)
                                
                                Text("123 kcal")
                                    .bold()
                            }
                            .padding(.bottom)
                            
                            VStack (alignment: .leading, spacing: 8) {
                                Text("Active")
                                    .font(.callout)
                                    .bold()
                                    .foregroundColor(.green)
                                
                                Text("52 mins")
                                    .bold()
                            }
                            .padding(.bottom)
                            
                            VStack (alignment: .leading, spacing: 8) {
                                Text("Stand")
                                    .font(.callout)
                                    .bold()
                                    .foregroundColor(.red)
                                
                                Text("8 hours")
                                    .bold()
                            }
                        }
                        
                        Spacer()
                        
                        ZStack {
                            ProgressCircleView(progress: $calories, goal: 600, color: .red)
                            
                            ProgressCircleView(progress: $active, goal: 60, color: .green)
                                .padding(.all, 20)
                            
                            ProgressCircleView(progress: $stand, goal: 12, color: .blue)
                                .padding(.all, 40)
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    .padding()
                    
                    HStack {
                        Text("Fitness Activity")
                        
                        Spacer()
                        
                        Button {
                            print("show more")
                        } label: {
                            Text("Show More")
                                .padding()
                                .foregroundColor(.white)
                                .background(.blue)
                                .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal)
                    
                    
                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)) {
                        ForEach(mockActivities, id: \.id) {
                            activity in
                            ActivityCard(activity: activity)
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Text("Recent Workouts")
                        
                        Spacer()
                        
                        NavigationLink {
                            EmptyView()
                        } label: {
                            Text("Show More")
                                .padding()
                                .foregroundColor(.white)
                                .background(.blue)
                                .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    LazyVStack {
                        ForEach(mockWorkouts, id: \.id) { workout in
                            WorkoutCard(workout: workout)
                        }
                    }
                    .padding(.bottom)
                }
                
            }
            
        }
    }
        
}

#Preview {
    HomeView()
}
