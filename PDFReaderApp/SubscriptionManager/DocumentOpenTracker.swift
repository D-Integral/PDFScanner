//
//  DocumentOpenTracker.swift
//  PDF Reader
//
//  Created by Dmytro Skorokhod on 09.10.2024.
//

import Foundation
import Combine

class DocumentOpenTracker: ObservableObject {
    @Published var openCount: Int = 0
    let userDefaults = UserDefaults.standard
    let openCountKey = "documentOpenCount"
    let lastOpenDateKey = "lastOpenDate"
    private let daysInUsageKey = "daysInUsageKey"

    init() {
        loadOpenCount()
    }
    
    // Load the count and check if it's the same day
    func loadOpenCount() {
        if let lastDate = userDefaults.object(forKey: lastOpenDateKey) as? Date,
           Calendar.current.isDateInToday(lastDate) {
            // If it's the same day, load the count
            openCount = userDefaults.integer(forKey: openCountKey)
        } else {
            // If it's a new day, reset the count
            openCount = 0
            userDefaults.set(0, forKey: openCountKey)
            
            userDefaults.set(daysInUsage + 1,
                             forKey: daysInUsageKey)
        }
    }

    // Increment the open count
    func incrementOpenCount() {
        openCount += 1
        userDefaults.set(openCount, forKey: openCountKey)
        userDefaults.set(Date(), forKey: lastOpenDateKey)  // Save the current date
    }
    
    var daysInUsage: Int {
        return userDefaults.integer(forKey: daysInUsageKey)
    }
}

