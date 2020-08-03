//
//  NewsFilterView.swift
//  DailyNews
//
//  Created by Karthick Ramasamy on 7/23/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import SwiftUI
import Combine

struct NewsFilterView: View {
    @ObservedObject var viewModel: NewsFilterViewModel
    @Environment(\.presentationMode) var presentationMode
    var makeNewsFilterRow: (String) -> CategoryFilterRowView
    var makeCountryNameRow: (String) -> CountryFilterRowView
    var applyNewsFilter: TopHeadlinesView.ApplyNewsFilter
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("Categories")) {
                    ForEach(self.viewModel.categories) {
                        self.makeNewsFilterRow($0.rawValue)
                    }
                }
                Section(header: Text("Countries")) {
                    ForEach(self.viewModel.countries) {
                        self.makeCountryNameRow($0.rawValue)
                    }
                }
            }
        }
        .navigationBarItems(leading:  Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.blue)
            }, trailing: Button(action: {
                self.applyNewsFilter()
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Apply")
        })
        .navigationBarTitle("Filters")
        .onAppear { self.viewModel.onAppear() }
    }
}

struct NewsFilterView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
