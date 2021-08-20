//
//  ImageCardWithText.swift
//  Game Catalogue
//
//  Created by Rudiyanto on 19/08/21.
//

import SwiftUI

struct ImageCardWithText: View {
    private let imageUrl: String
    private let label: String?
    private let onPress: (() -> Void)?

    init(_ imageUrl: String, label: String? = nil, onPress: (() -> Void)? = nil) {
        self.imageUrl = imageUrl
        self.label = label
        self.onPress = onPress
    }

    private let gradientColor = Gradient(
        colors: [
            Color(red: 0, green: 0, blue: 0, opacity: 0.7),
            Color(red: 1, green: 1, blue: 1, opacity: 0)
        ]
    )

    var body: some View {
        ZStack {
            LoadableImage(imageUrl) { image in
                image.resizable()
                    .clipped()
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight: .infinity,
                        alignment: .center
                    )
            }
            LinearGradient(
                gradient: gradientColor,
                startPoint: .bottom,
                endPoint: .top
            )
            if label != nil {
                VStack {
                    Spacer()
                    Text(label!)
                        .fontWeight(.bold)
                        .padding(.bottom, 6)
                        .foregroundColor(.white)
                        .font(.title2)
                }
            }
        }
        .onTapGesture { self.onPress?() }
        .cornerRadius(4)
    }
}
