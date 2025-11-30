  //
//  ProfileView.swift
//  FitnessApp
//
//  Created by Mayank Pandey on 30/11/25.
//

import SwiftUI

struct ProfileView: View {
    @AppStorage("profileName") var profileName: String?
    @AppStorage("profileImage") var profileImage: String?
    
    @State private var isEditingName = false
    @State private var currentName = ""
    
    @State private var selectedImage: String?
    @State private var isEditingImage = false
    
    var images = ["profile1", "profile2", "profile3", "profile4", "profile5", "profile6", "profile7"]

    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Image(profileImage ?? "profile1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.all, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.gray.opacity(0.25))
                    )
                    .onTapGesture {
                        withAnimation {
                            isEditingName = false
                            isEditingImage = true
                        }
                    }
                VStack(alignment: .leading) {
                    Text("Good Morning,")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                        .minimumScaleFactor(0.5)
                    
                    Text(profileName ?? "Name")
                        .font(.title)
                }
            }
            
            if isEditingName {
                TextField("Name...", text: $currentName)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke()
                    )
                HStack {
                    FitnessProfileEditButton(title: "Cancel", backgroundColor: .gray.opacity(0.1)) {
                        withAnimation {
                            isEditingName = false
                        }
                    }
                    .foregroundColor(.red)
                    
                    FitnessProfileEditButton(title: "Done", backgroundColor: .primary) {
                        withAnimation {
                            profileName = currentName
                            isEditingName = false
                        }
                    }
                    .foregroundColor(Color(uiColor: .systemBackground))
                    .padding(.bottom)
                }
            }
            
            if isEditingImage {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(images, id: \.self) { image in
                            Button {
                                withAnimation {
                                    selectedImage = image
                                }
                            } label: {
                                VStack {
                                    Image(image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .padding()
                                    if selectedImage == image {
                                        Circle()
                                            .frame(width: 16, height: 16)
                                            .foregroundColor(.primary)
                                    }
                                }
                                .padding()
                            }
                            
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.gray.opacity(0.15))
                )
                
                Button {
                    withAnimation {
                        profileImage = selectedImage
                        isEditingImage = false
                    }
                } label: {
                    Text("Done")
                        .padding()
                        .frame(maxWidth: 200)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.black)
                        )
                        .foregroundColor(.white)
                }
                .padding(.vertical)
            }
            
            VStack {
                FitnessProfileItemButton(image: "square.and.pencil", title: "Edit Name") {
                    isEditingName = true
                    isEditingImage = false
                }
                
                FitnessProfileItemButton(image: "square.and.pencil", title: "Edit Image") {
                    print("image")
                    withAnimation {
                        isEditingName = false
                        isEditingImage = true
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.15))
            )
            
            VStack {
                FitnessProfileItemButton(image: "envelope", title: "Contact Us") {
                    print("contact")
                }
                
                FitnessProfileItemButton(image: "doc", title: "Privacy Policy") {
                    print("privacy")
                }
                
                FitnessProfileItemButton(image: "doc", title: "Terms of Service") {
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
        .onAppear {
            selectedImage = profileImage
        }
    }
}

#Preview {
    ProfileView()
}
