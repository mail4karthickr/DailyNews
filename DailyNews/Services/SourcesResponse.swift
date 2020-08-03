//
//  Sources.swift
//  DailyNews
//
//  Created by Karthick Ramasamy on 7/17/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation

struct SourcesResponse: Codable {
    let status: String
    let sources: [Source]
}

extension Country: Codable {}
