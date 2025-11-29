//
//  ActivityCard.swift
//  FitnessApp
//
//  Created by Mayank Pandey on 27/11/25.
//

import SwiftUI

func formatAmount(_ value: String) -> String {
    let cleaned = value.replacingOccurrences(of: ",", with: "")
    
    let pattern = "[0-9]+(?:\\.[0-9]+)?"
    
    if let range = cleaned.range(of: pattern, options: .regularExpression) {
        let numberString = String(cleaned[range])
        
        if let number = Double(numberString) {
            return String(Int(number.rounded()))
        }
    }
    return value
}



struct ActivityCard: View {
    @State var activity: Activity
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .cornerRadius(15)
            
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(activity.title)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        
                        Text(activity.subtitle)
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    Image(systemName: activity.image)
                        .foregroundColor(activity.tintColor)
                    
                }
                
                Text(formatAmount(activity.amount))
                    .font(.title)
                    .bold()
                    .padding()

            }
            .padding()
        }
    }
}

#Preview {
    ActivityCard(activity: Activity(
        title: "Today Steps",
        subtitle: "Goal 12,000",
        image: "figure.walk",
        tintColor: Color.green,
        amount: "9812"
    ))
}
