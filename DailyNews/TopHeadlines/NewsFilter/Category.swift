//
//  Category.swift
//  DailyNews
//
//  Created by Karthick Ramasamy on 7/18/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation

enum Category: String, CaseIterable, Identifiable {
    var id: UUID { UUID() }
    case business, entertainment, general, health, science, sports, technology
}
