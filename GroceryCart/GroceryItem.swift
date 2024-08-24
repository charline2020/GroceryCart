//
//  GroceryItem.swift
//  GroceryCart
//
//  Created by Charline on 2024/8/23.
//

import Foundation

struct GroceryItem: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var amount: Int = 1
    var date: Date
}
