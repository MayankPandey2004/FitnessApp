//
//  LeaderboardView.swift
//  FitnessApp
//
//  Created by Mayank Pandey on 30/11/25.
//

import SwiftUI
import Combine

struct LeaderboardUser: Codable, Identifiable {
    let id: Int
    let createdAt: String
    let username: String
    let count: Int
}

class LeaderboardViewModel: ObservableObject {
    @Published var mockData = [
        LeaderboardUser(id: 0, createdAt: "2025-11-20", username: "jason", count: 4124),
        LeaderboardUser(id: 1, createdAt: "2025-11-19", username: "mayank", count: 3890),
        LeaderboardUser(id: 2, createdAt: "2025-11-18", username: "alex", count: 3651),
        LeaderboardUser(id: 3, createdAt: "2025-11-17", username: "sophia", count: 3547),
        LeaderboardUser(id: 4, createdAt: "2025-11-16", username: "rahul", count: 3398),
        LeaderboardUser(id: 5, createdAt: "2025-11-15", username: "emma", count: 3312),
        LeaderboardUser(id: 6, createdAt: "2025-11-14", username: "liam", count: 3230),
        LeaderboardUser(id: 7, createdAt: "2025-11-13", username: "ananya", count: 3158),
        LeaderboardUser(id: 8, createdAt: "2025-11-12", username: "daniel", count: 2987),
        LeaderboardUser(id: 9, createdAt: "2025-11-11", username: "olivia", count: 2841),
        LeaderboardUser(id: 10, createdAt: "2025-11-10", username: "katie", count: 2795)
    ]
}

struct LeaderboardView: View {
    @StateObject var viewModel = LeaderboardViewModel()
    @AppStorage("username") var username: String?
    
    @Binding var showTerms: Bool
    
    var body: some View {
        VStack {
            Text("Leaderboard")
                .font(.largeTitle)
                .bold()
            HStack {
                Text("Name")
                
                Spacer()
                
                Text("Steps")
                    .bold()
            }
            .padding()
            
            LazyVStack(spacing: 24) {
                ForEach(viewModel.mockData) { person in
                    HStack {
                        Text("\(person.id).")
                        
                        Text(person.username)
                        
                        Spacer()
                        
                        Text("\(person.count)")
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .fullScreenCover(isPresented: $showTerms) {
            TermsView()
        }
    }
}

#Preview {
    LeaderboardView(showTerms: .constant(true))
}
