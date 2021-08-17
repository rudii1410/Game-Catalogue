//
//  ProfileScreen.swift
//  Game Catalogue
//
//  Created by Rudiyanto on 14/08/21.
//

import SwiftUI

struct ProfileScreen: View {
    var body: some View {
        NavigationView {
            VStack {
                AsyncImage(urlStr: "https://rudiyanto.dev/img/self.jpg")
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
            .navigationBarTitle("My Profile", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
