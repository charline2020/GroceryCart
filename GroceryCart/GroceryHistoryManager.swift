//
//  GroceryHistoryManager.swift
//  GroceryCart
//
//  Created by Charline on 2024/8/23.
//

import Foundation
import SwiftUI

class GroceryHistoryManager: ObservableObject {
    @Published var items: [GroceryItem] = []
    @Published var purchasedItems: [Date: [GroceryItem]] = [:]
    @Published var missingItems: [Date: [GroceryItem]] = [:]

    private let itemsKey = "GroceryHistoryItems"

    init() {
        loadItems()
    }

    // Add a single purchased item with date
    func addPurchasedItem(_ item: GroceryItem, date: Date) {
        let normalizedDate = date.withoutTime()
        if var itemsForDate = purchasedItems[normalizedDate] {
            itemsForDate.append(item)
            purchasedItems[normalizedDate] = itemsForDate
        } else {
            purchasedItems[normalizedDate] = [item]
        }
        save()
    }

    // Add purchased items for a specific date
    func addPurchasedItems(_ items: [GroceryItem], date: Date) {
        let normalizedDate = date.withoutTime() // Normalize the date
        if purchasedItems[normalizedDate] != nil {
            purchasedItems[normalizedDate]?.append(contentsOf: items)
        } else {
            purchasedItems[normalizedDate] = items
        }
        save()
    }


    // Remove items for a specific date
    func removeItems(_ items: [GroceryItem], date: Date) {
        if purchasedItems[date] != nil {
            purchasedItems[date]?.removeAll { item in items.contains { $0.id == item.id } }
            if purchasedItems[date]?.isEmpty == true {
                purchasedItems.removeValue(forKey: date)
            }
        }
        if missingItems[date] != nil {
            missingItems[date]?.removeAll { item in items.contains { $0.id == item.id } }
            if missingItems[date]?.isEmpty == true {
                missingItems.removeValue(forKey: date)
            }
        }
        save()
    }

    // Save items to UserDefaults
    func save() {
        let encoder = JSONEncoder()
        if let encodedPurchased = try? encoder.encode(purchasedItems),
           let encodedMissing = try? encoder.encode(missingItems) {
            UserDefaults.standard.set(encodedPurchased, forKey: "\(itemsKey)_purchased")
            UserDefaults.standard.set(encodedMissing, forKey: "\(itemsKey)_missing")
            
            // Debugging output
            print("Saved Purchased Items: \(purchasedItems)")
            print("Saved Missing Items: \(missingItems)")
        }
    }

    func addItem(_ item: GroceryItem) {
        // Ensure no duplicates
        if !items.contains(where: { $0.id == item.id }) {
            items.append(item)
            saveItems()
        } else {
            print("Item with ID \(item.id) already exists.")
        }
    }

    // Remove a single item from the current list
    func removeItem(_ item: GroceryItem) {
        // Remove item from the current grocery list
        items.removeAll { $0.id == item.id }

        // Optionally, also remove item from history if needed
        // Example: remove item from purchased and missing items if necessary
        let currentDate = Date()
        removeItems([item], date: currentDate)

        // Save the updated state
        save()
    }

    // Add missing items for a specific date
    func addMissingItems(_ items: [GroceryItem], date: Date) {
        let dateWithoutTime = date.withoutTime() // Normalize the date
        if missingItems[dateWithoutTime] != nil {
            missingItems[dateWithoutTime]?.append(contentsOf: items)
        } else {
            missingItems[dateWithoutTime] = items
        }
        save()
    }

    func saveItems() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: itemsKey)
        }
    }

    func loadItems() {
        if let savedPurchased = UserDefaults.standard.data(forKey: "\(itemsKey)_purchased"),
           let decodedPurchased = try? JSONDecoder().decode([Date: [GroceryItem]].self, from: savedPurchased) {
            purchasedItems = decodedPurchased
            
            // Debugging output
            print("Loaded Purchased Items: \(purchasedItems)")
        }
        
        if let savedMissing = UserDefaults.standard.data(forKey: "\(itemsKey)_missing"),
           let decodedMissing = try? JSONDecoder().decode([Date: [GroceryItem]].self, from: savedMissing) {
            missingItems = decodedMissing
            
            // Debugging output
            print("Loaded Missing Items: \(missingItems)")
        }
    }
    
    // Method to clear history items for a specific day
        func clearHistory(for date: Date) {
            let normalizedDate = date.withoutTime()
            purchasedItems.removeValue(forKey: normalizedDate)
            missingItems.removeValue(forKey: normalizedDate)
            save()
        }
    
    
}
