//
//  This file is part of Game Catalogue.
//
//  Game Catalogue is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  Game Catalogue is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with Game Catalogue.  If not, see <https://www.gnu.org/licenses/>.
//

import SwiftUI
import SDWebImageSwiftUI

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
            WebImage(url: URL(string: imageUrl))
                .defaultPlaceholder()
                .resizable()
                .clipped()
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .center
                )
            LinearGradient(
                gradient: gradientColor,
                startPoint: .bottom,
                endPoint: .top
            )
            if label != nil {
                VStack {
                    Spacer()
                    Text(label ?? "")
                        .fontWeight(.bold)
                        .padding(.bottom, 6)
                        .padding(.horizontal, 8)
                        .foregroundColor(.white)
                        .font(.title2)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .onTapGesture { self.onPress?() }
        .cornerRadius(4)
    }
}
