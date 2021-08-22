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

struct ProfileScreen: View {
    var body: some View {
        VStack {
            LoadableImage("https://rudiyanto.dev/img/self.jpg") { image in
                image.resizable()
                    .frame(
                        minWidth: 100,
                        idealWidth: 200,
                        maxWidth: 250,
                        minHeight: 100,
                        idealHeight: 200,
                        maxHeight: 250,
                        alignment: .center
                    )
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(10)
            }
            Text("Rudiyanto")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 10)
                .padding(.bottom, 1)
            Button("https://rudiyanto.dev") {
                guard let url = URL(string: "https://rudiyanto.dev/") else { return }
                UIApplication.shared.open(url)
            }
        }
    }
}
