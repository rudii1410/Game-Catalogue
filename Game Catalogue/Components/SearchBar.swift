//
//  SearchBaar.swift
//  Game Catalogue
//
//  Created by Rudiyanto on 17/08/21.
//  https://www.appcoda.com/swiftui-search-bar/

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    @State private var isEditing: Bool = false

    var body: some View {
        HStack {
            TextField("Search...", text: $searchText)
                .padding(8)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .frame(maxWidth: .infinity, alignment: .leading)
                .cornerRadius(8)
                .onTapGesture {
                    withAnimation(.easeIn(duration: 0.2)) {
                        isEditing = true
                    }
                }
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)

                        if isEditing {
                            Button(action: {
                                searchText = ""
                            }, label: {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            })
                        }
                    }
                )

            if isEditing {
                Button("Cancel") {
                    withAnimation(.easeOut(duration: 0.2)) {
                        self.isEditing = false
                        self.searchText = ""
                    }
                }
                .transition(.move(edge: .trailing))
            }
        }
    }
}
