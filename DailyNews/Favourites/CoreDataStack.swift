//
//  CoreDataStack.swift
//  DailyNews
//
//  Created by Karthick Ramasamy on 8/2/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataStack {
  // 2
  static var viewContext: NSManagedObjectContext = {
    let container = NSPersistentContainer(name: "DailyNews")

    container.loadPersistentStores { _, error in
      guard error == nil else {
        fatalError("\(#file), \(#function), \(error!.localizedDescription)")
      }
    }

    return container.viewContext
  }()

  // 3
  static func save() {
    guard viewContext.hasChanges else { return }

    do {
      try viewContext.save()
    } catch {
      fatalError("\(#file), \(#function), \(error.localizedDescription)")
    }
  }
}
