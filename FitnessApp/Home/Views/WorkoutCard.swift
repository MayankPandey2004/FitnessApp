//
//  WorkoutCard.swift
//  FitnessApp
//
//  Created by Mayank Pandey on 27/11/25.
//

import SwiftUI

struct WorkoutCard: View {
    @State var workout: Workout
    var body: some View {
        HStack {
            Image(systemName: workout.image)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(workout.tintColor)
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
            
            VStack(spacing: 16) {
                HStack {
                    Text(workout.title)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .font(.title3)
                        .bold()
                        
                    Spacer()
                    
                    Text(workout.duration)
                }
                
                HStack {
                    Text(workout.date)
                    
                    Spacer()
                    
                    Text(workout.calories)
                }
            }
        }
        .padding(.horizontal)
        
    }
}

#Preview {
    WorkoutCard(workout: Workout(id: 0, title: "Running", image: "figure.run", tintColor: Color.cyan, duration: "51 mins", date: "Aug 1", calories: "512"))
}
