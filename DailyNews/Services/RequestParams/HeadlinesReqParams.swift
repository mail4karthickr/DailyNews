//
//  TopHeadlinesForCountryRequests.swift
//  DailyNews
//
//  Created by Karthick Ramasamy on 7/19/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation

struct HeadlinesReqParams {
    let country: Country
    let category: Category?
    let keyword: String? = nil
    let pageSize: String? = nil
    let page: String? = nil
}
