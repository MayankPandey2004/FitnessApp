// PaywallView.swift
// FitnessApp

import SwiftUI

struct PaywallView: View {
    
    @StateObject var viewModel = PaywallViewModel()
    
    var body: some View {
        VStack {
            Text("Premium Membership")
                .font(.largeTitle)
                .bold()
                .padding(.top)
            
            Text("Get fit, get active, today")
                .font(.subheadline)
                .padding(.bottom, 20)
            
            Spacer()
            
            VStack(spacing: 20) {
                featureRow("Exercise boosts energy levels.")
                featureRow("Track workouts with detailed insights.")
                featureRow("Unlock all premium tools.")
            }
            .padding()
            
            Spacer()
            
            VStack(spacing: 16) {
                ForEach(viewModel.packages) { pkg in
                    Button {
                        print("Selected: \(pkg.title)")
                    } label: {
                        VStack(spacing: 6) {
                            Text(pkg.title)
                                .font(.headline)
                            Text(pkg.price)
                                .font(.subheadline)
                                .foregroundColor(.green)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.green, lineWidth: 2)
                        )
                    }
                }
            }
            .padding(.horizontal, 24)
            
            Button {
                print("Restore tapped")
            } label: {
                Text("Restore Purchases")
                    .foregroundColor(.green)
                    .underline()
                    .padding(.top, 10)
            }
            
            HStack(spacing: 16) {
                Link("Terms of Use (EULA)", destination: URL(string: "https://github.com/MayankPandey2004/")!)
                Link("Privacy Policy", destination: URL(string: "https://www.linkedin.com/in/mayankpandey2004/")!)
            }
            .font(.footnote)
            .padding(.top, 12)
            
            Spacer(minLength: 20)
        }
        .frame(maxWidth: .infinity, alignment: .top)
    }
    
    func featureRow(_ text: String) -> some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
            Text(text)
                .font(.system(size: 14))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    PaywallView()
}
