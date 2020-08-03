//
//  CountryNameRowView.swift
//  DailyNews
//
//  Created by Karthick Ramasamy on 7/26/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import SwiftUI

struct CountryFilterRowView: View {
    @ObservedObject var viewModel: CountryFilterRowViewModel
    var country: String
    
    var body: some View {
        Button(action: { self.viewModel.countrySelected() }) {
            HStack {
                Text(country)
                Spacer()
                if self.viewModel.isSelected {
                    Image(systemName: "checkmark")
                }
            }
        }
        .onAppear { self.viewModel.onAppear(country: self.country) }
    }
}
