 //
//  ProfileView.swift
//  FitnessApp
//
//  Created by Mayank Pandey on 30/11/25.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Image("profile1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.all, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.gray.opacity(0.25))
                    )
                VStack(alignment: .leading) {
                    Text("Good Morning,")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    
                    Text("Name")
                        .font(.title)
                }
            }
            VStack {
                FitnessProfileButton(image: "square.and.pencil", title: "Edit Name") {
                    print("name")
                }
                
                FitnessProfileButton(image: "square.and.pencil", title: "Edit Image") {
                    print("image")
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.15))
            )
            
            VStack {
                FitnessProfileButton(image: "envelope", title: "Contact Us") {
                    print("contact")
                }
                
                FitnessProfileButton(image: "doc", title: "Privacy Policy") {
                    print("privacy")
                }
                
                FitnessProfileButton(image: "doc", title: "Terms of Service") {
                    print("terms")
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.15))
            )

        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        
        
    }
}

#Preview {
    ProfileView()
}
