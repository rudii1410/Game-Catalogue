//
//  SectionTitleModifier.swift
//  Game Catalogue
//
//  Created by Rudiyanto on 15/08/21.
//

import SwiftUI

extension Text {
    func asSectionTitle() -> some View {
        self.font(.title2)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
