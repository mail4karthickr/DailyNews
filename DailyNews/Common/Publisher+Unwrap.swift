//
//  Publisher+Unwrap.swift
//  DailyNews
//
//  Created by Karthick Ramasamy on 7/21/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation
import Combine

extension Publisher {
  // 1
  func unwrap<T>() -> Publishers.CompactMap<Self, T> where Output == Optional<T> {
    // 2
    compactMap { $0 }
  }
}
