//
//  SearchBar.swift
//  DailyNews
//
//  Created by Karthick Ramasamy on 7/28/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @Binding var isSearchEnabled: Bool
    @State private var isEditing = false
    var searchButtonTapped: (String) -> ()
    
    var body: some View {
        HStack {
            TextField("Search...", text: $text)
                .padding(.vertical, 7)
                .padding(.horizontal, 40)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                             .foregroundColor(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding()
                        Button(action: { self.text = "" }) {
                            Image(systemName: "multiply.circle.fill")
                            .foregroundColor(.gray)
                            .padding(.trailing, 8)
                        }
                    }
                )
                .padding(.horizontal, 5)
                
                Button(action: { self.searchButtonTapped(self.text) }) {
                    Text("Search")
                }
                .disabled(!isSearchEnabled)
                .padding(.trailing, 10)
                .foregroundColor(isSearchEnabled ? .blue : .gray)
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant("text"), isSearchEnabled: .constant(false)) { text in
            
        }
    }
}
