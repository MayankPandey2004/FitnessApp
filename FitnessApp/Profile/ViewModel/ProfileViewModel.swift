//
//  ProfileViewModel.swift
//  FitnessApp
//
//  Created by Mayank Pandey on 01/12/25.
//

import Foundation
import SwiftUI
import Combine

class ProfileViewModel: ObservableObject {
    @Published var isEditingName = false
    @Published var currentName = ""
    @Published var profileName = UserDefaults.standard.string(forKey: "profileName")
    
    @Published var profileImage = UserDefaults.standard.string(forKey: "profileImage")
    @Published var selectedImage: String? = UserDefaults.standard.string(forKey: "profileImage") ?? "profile1"
    @Published var isEditingImage = false
    
    var images = ["profile1", "profile2", "profile3", "profile4", "profile5", "profile6", "profile7"]
    
    func presentEditName() {
        isEditingName = true
        isEditingImage = false
    }
    
    func presentEditImage() {
        isEditingName = false
        isEditingImage = true
    }
    
    func dismissEdit() {
        isEditingName = false
        isEditingImage = false
    }
    
    func setNewName() {
        profileName = currentName
        withAnimation {
            UserDefaults.standard.setValue(currentName, forKey: "profileName")
            self.dismissEdit()
        }
    }
    
    func didSelectImage(name: String) {
        selectedImage = name
    }
    
    func setNewImage() {
        profileImage = selectedImage
        withAnimation {
            UserDefaults.standard.setValue(selectedImage, forKey: "profileImage")
            self.dismissEdit()
        }
    }
    
    func presentEmailApp() {
        let emailSubject = "Fitness App - Contact Us"
        let emailRecipient = "mpandey2004@gmail.com"
        
        let encodedSubject = emailSubject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedRecipient = emailRecipient.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let urlString = "mailto:\(encodedRecipient)?subject=\(encodedSubject)"
        
        guard let url = URL(string: urlString) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            return
        }
    }
}
