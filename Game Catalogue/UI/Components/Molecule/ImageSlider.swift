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

struct ImageSlider: View {
    private static let SPACING: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 24 : 12
    private static let RATIO: CGFloat = 0.85
    private static let IMAGEWIDTH: CGFloat = UIScreen.main.bounds.width

    var height: CGFloat = 0.35 * UIScreen.main.bounds.height
    @Binding var urls: [String]
    var onPress: ((Int) -> Void)?

    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    @State private var activeIdx = 0

    var body: some View {
        GeometryReader { proxy in
            TabView(selection: $activeIdx) {
                ForEach(0..<self.urls.count, id: \.self) { idx in
                    WebImage(url: URL(string: urls[idx]))
                        .defaultPlaceholder()
                        .resizable()
                        .scaledToFill()
                        .tag(idx)
                        .onTapGesture {
                            self.onPress?(idx)
                        }
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .frame(width: proxy.size.width, height: proxy.size.height)
            .onReceive(self.timer) { _ in
                let dataSum = self.urls.isEmpty ? 1 : self.urls.count
                self.activeIdx = (self.activeIdx + 1) % dataSum
            }
        }
    }
}
