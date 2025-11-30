//
//  FitnessProfileButton.swift
//  FitnessApp
//
//  Created by Mayank Pandey on 30/11/25.
//

import SwiftUI

struct FitnessProfileItemButton: View {
    @State var image: String
    @State var title: String
    var action: (() -> Void)
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: image)
                Text(title)
            }
            .foregroundColor(.primary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    FitnessProfileItemButton(image: "square.and.pencil", title: "Edit Image") {}
}
