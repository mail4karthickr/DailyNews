//
//  NewsFilterRow.swift
//  DailyNews
//
//  Created by Karthick Ramasamy on 7/25/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import SwiftUI

struct CategoryFilterRowView: View {
    @ObservedObject var viewModel: CategoryFilterRowViewModel
    var category: String
    
    var body: some View {
        Button(action: { self.viewModel.categorySelected() }) {
            HStack {
                Text(category)
                Spacer()
                if self.viewModel.isSelected {
                    Image(systemName: "checkmark")
                }
            }
        }
        .onAppear { self.viewModel.onAppear(category: self.category) }
    }
}
