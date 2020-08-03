//
//  GetAllNewsWithKeyword.swift
//  DailyNews
//
//  Created by Karthick Ramasamy on 7/19/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation

struct GetAllNewsWithKeyword {
    let keyword: String
    let language: Country?
    let pageSize: String?
    let page: String?
    let from: Date?
    let to: Date?
}
