//
//  LoadingView.swift
//  Game Catalogue
//
//  Created by Rudiyanto on 19/08/21.
//

import SwiftUI

struct LoadingView: View {
    let loadingText: String? = nil

    var body: some View {
        HStack(alignment: .center, spacing: 6) {
            Spacer()
            ProgressView()
            Text(self.loadingText ?? "Fetching more data for you, hang tight!")
                .font(.system(size: 12))
                .fontWeight(.medium)
            Spacer()
        }
    }
}
