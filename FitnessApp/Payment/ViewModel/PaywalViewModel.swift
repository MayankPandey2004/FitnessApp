// PaywallViewModel.swift
// FitnessApp

import Foundation
import SwiftUI
import Combine

class PaywallViewModel: ObservableObject {
    @Published var packages: [PaywallPackage] = []
    
    init() {
        loadMockPackages()
    }
    
    private func loadMockPackages() {
        packages = [
            PaywallPackage(title: "Monthly Plan", price: "$4.99"),
            PaywallPackage(title: "Yearly Plan", price: "$39.99"),
            PaywallPackage(title: "Lifetime Access", price: "$99.99")
        ]
    }
}
