//
//  SectionTitle.swift
//  Game Catalogue
//
//  Created by Rudiyanto on 15/08/21.
//

import SwiftUI

struct SectionTitle: View {
    var text: String = ""
    var body: some View {
        Text(text)
            .font(.title2)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
    }
}
