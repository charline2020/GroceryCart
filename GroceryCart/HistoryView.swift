//
//  HistoryView.swift
//  GroceryCart
//
//  Created by Charline on 2024/8/23.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var historyManager: GroceryHistoryManager
    @State private var expandedDates: Set<Date> = []

    var body: some View {
        ScrollView {
            ForEach(filteredDates(), id: \.self) { date in
                DisclosureGroup(
                    isExpanded: Binding(
                        get: { expandedDates.contains(date) },
                        set: { isExpanded in
                            if isExpanded {
                                expandedDates.insert(date)
                            } else {
                                expandedDates.remove(date)
                            }
                        }
                    ),
                    content: {
                        if let purchased = historyManager.purchasedItems[date], !purchased.isEmpty {
                            Section(header: Text("Purchased Items").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading)) {
                                ForEach(purchased) { item in
                                    HStack {
                                        Text(item.name)
                                        Spacer()
                                        Text("\(item.amount)")
                                    }
                                }
                            }
                        }

                        if let missing = historyManager.missingItems[date], !missing.isEmpty {
                            Section(header: Text("Missing Items").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading)) {
                                ForEach(missing) { item in
                                    HStack {
                                        Text(item.name)
                                        Spacer()
                                        Text("\(item.amount)")
                                    }
                                }
                                .listStyle(PlainListStyle())
                            }
                        }
                    },
                    label: {
                        Text(dateFormatted(date))
                            .font(.headline)
                            .padding(.bottom, 5)
                    }
                )
            }
        }
        .padding()
        .onAppear {
            // Print to check data when view appears
            print("History View Purchased Items: \(historyManager.purchasedItems)")
            print("History View Missing Items: \(historyManager.missingItems)")
        }
    }

    // Filter dates to include only those with items
    private func filteredDates() -> [Date] {
        let dates = Set(historyManager.purchasedItems.keys.map { $0.withoutTime() })
            .union(Set(historyManager.missingItems.keys.map { $0.withoutTime() }))
            .filter { date in
                !(historyManager.purchasedItems[date]?.isEmpty ?? true) ||
                    !(historyManager.missingItems[date]?.isEmpty ?? true)
            }
        return Array(dates).sorted(by: >)
    }

    // Format date for display
    private func dateFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    HistoryView()
        .environmentObject(GroceryHistoryManager())
        .frame(width: 400, height: 600)
}
