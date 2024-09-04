//
//  ContentView.swift
//
//  Created by Charline on 2024/8/19.
//

import SwiftUI

struct ContentView: View {
    @StateObject var historyManager = GroceryHistoryManager()

    var body: some View {
        VStack {
            AddGroceryView()
                .environmentObject(historyManager)
        }
    }
}

extension Date {
    func withoutTime() -> Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: self)
    }
}

#Preview {
    ContentView()
        .frame(width: 400, height: 600)
}
