//
//  LeaderboardView.swift
//  FitnessApp
//
//  Created by Mayank Pandey on 30/11/25.
//

import SwiftUI
import Combine

struct LeaderboardUser: Codable, Identifiable {
    var id = UUID()
    let username: String
    let count: Int
}

class LeaderboardViewModel: ObservableObject {
    @Published var mockData = [
        LeaderboardUser(username: "jason", count: 4124),
        LeaderboardUser(username: "mayank", count: 3890),
        LeaderboardUser(username: "alex", count: 3651),
        LeaderboardUser(username: "sophia", count: 3547),
        LeaderboardUser(username: "rahul", count: 3398),
        LeaderboardUser(username: "emma", count: 3312),
        LeaderboardUser(username: "liam", count: 3230),
        LeaderboardUser(username: "ananya", count: 3158),
        LeaderboardUser(username: "daniel", count: 2987),
        LeaderboardUser(username: "olivia", count: 2841),
        LeaderboardUser(username: "katie", count: 2795)
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
                        Text("1.")
                        
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
        .task {
            do {
                try await DatabaseManager.shared.postStepCountUpdateFor(username: "jason", count: 1240)
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
}

#Preview {
    LeaderboardView(showTerms: .constant(true))
}
