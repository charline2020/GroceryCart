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
        List {
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
                        VStack(content: {
                            if let purchased = historyManager.purchasedItems[date], !purchased.isEmpty {
                                VStack {
                                    HStack {
                                        Text("Purchased Items")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .fontWeight(.bold)
                                            .foregroundColor(.blue)
                                            .font(.system(size: 16))

                                        Text("#")
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                            .fontWeight(.bold)
                                            .foregroundColor(.blue)
                                            .font(.system(size: 16))
                                    }
                                    Section {
                                        ForEach(purchased) { item in
                                            HStack {
                                                Image(systemName: "smallcircle.fill.circle.fill")
                                                    .font(.system(size: 6)) // Set the size of the image
                                                Text(item.name)
                                                Spacer()
                                                Text("\(item.amount)")
                                            }
                                        }
                                    }
                                }
                            }

                            Divider()

                            if let missing = historyManager.missingItems[date], !missing.isEmpty {
                                VStack {
                                    HStack {
                                        Text("Missing Items")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .fontWeight(.bold)
                                            .foregroundColor(.orange)
                                            .font(.system(size: 16))

                                        Text("#")
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                            .fontWeight(.bold)
                                            .foregroundColor(.orange)
                                            .font(.system(size: 16))
                                    }
                                    Section {
                                        ForEach(missing) { item in
                                            HStack {
                                                Image(systemName: "smallcircle.fill.circle.fill")
                                                    .font(.system(size: 6)) // Set the size of the image

                                                Text(item.name)
                                                Spacer()
                                                Text("\(item.amount)")
                                            }
                                        }
                                    }
                                }
                            }

                        })
                        .padding()
                        .background()
                        .overlay(
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(.gray, lineWidth: 2)
                                .shadow(radius: 1)
                        )
                    },

                    label: {
                        Text(dateFormatted(date))
                            .font(.system(size: 16))
                            .bold()
                            .padding(.bottom, 5)
                    }
                )
            }
        }
        .padding(12)
        .background()
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
