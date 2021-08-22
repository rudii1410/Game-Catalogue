//
//  GameDetailScreen.swift
//  Game Catalogue
//
//  Created by Rudiyanto on 19/08/21.
//

import SwiftUI

struct GameDetailScreen: View {
    @ObservedObject private var model = GameDetailScreenViewModel()

    var body: some View {
        ScrollView {
            ImageSlider(
                urls: self.$model.imageUrls
            )
            LazyVStack {
                Picker("", selection: self.$model.selectedTab) {
                    Text("About").tag(0)
                    Text("Info").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())

                switch self.model.selectedTab {
                case 0: AboutTab()
                case 1: InfoTab()
                default: AboutTab()
                }
            }
            .padding(.horizontal, 12)
        }
    }
}
