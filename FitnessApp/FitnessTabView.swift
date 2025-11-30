//
//  FitnessTabView.swift
//  FitnessApp
//
//  Created by Mayank Pandey on 27/11/25.
//

import SwiftUI

struct FitnessTabView: View {
    @AppStorage("username") var username: String?
    @State var selectedTab = "Home"
    @State var isPremium = false
    @State var showTerms = true
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()

        appearance.stackedLayoutAppearance.selected.iconColor = .green
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.green
        ]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(isPremium: $isPremium)
                .tag("Home")
                
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            ChartsView()
                .tag("Charts")
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Charts")
                }
            LeaderboardView(showTerms: $showTerms)
                .tag("Leaderboard")
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Leaderboard")
                }
            ProfileView()
                .tag("Profile")
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
        .onAppear {
            showTerms = username == nil
        }
    }
}

#Preview {
    FitnessTabView()
}
