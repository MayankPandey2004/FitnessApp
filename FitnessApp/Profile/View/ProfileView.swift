  //
//  ProfileView.swift
//  FitnessApp
//
//  Created by Mayank Pandey on 30/11/25.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Image(viewModel.profileImage ?? "profile1")
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
                            viewModel.presentEditImage()
                        }
                    }
                VStack(alignment: .leading) {
                    Text("Good Morning,")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                        .minimumScaleFactor(0.5)
                    
                    Text(viewModel.profileName ?? "Name")
                        .font(.title)
                }
            }
            
            if viewModel.isEditingName {
                TextField("Name...", text: $viewModel.currentName)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke()
                    )
                HStack {
                    FitnessProfileEditButton(title: "Cancel", backgroundColor: .gray.opacity(0.1)) {
                        withAnimation {
                            viewModel.dismissEdit()
                        }
                    }
                    .foregroundColor(.red)
                    
                    FitnessProfileEditButton(title: "Done", backgroundColor: .primary) {
                        withAnimation {
                            viewModel.setNewName()
                        }
                    }
                    .foregroundColor(Color(uiColor: .systemBackground))
                    .padding(.bottom)
                }
            }
            
            if viewModel.isEditingImage {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(viewModel.images, id: \.self) { image in
                            Button {
                                withAnimation {
                                    viewModel.didSelectImage(name: image)
                                }
                            } label: {
                                VStack {
                                    Image(image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .padding()
                                    if viewModel.selectedImage == image {
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
                        viewModel.setNewImage()
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
                    viewModel.presentEditName()
                }
                
                FitnessProfileItemButton(image: "square.and.pencil", title: "Edit Image") {
                    print("image")
                    withAnimation {
                        viewModel.presentEditImage()
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
            viewModel.selectedImage = viewModel.profileImage
        }
    }
}

#Preview {
    ProfileView()
}
