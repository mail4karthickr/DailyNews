//
//  TopHeadlinesForCountryRequests.swift
//  DailyNews
//
//  Created by Karthick Ramasamy on 7/19/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation

struct HeadlinesFromSourcesReqParams {
    let sources: [String]
    let pageSize: String?
    let page: String?
}
