//
//  DetailView.swift
//  Cart
//
//  Created by Charline on 2024/8/21.
//

import SwiftUI

struct DetailView: View {
    var selectedItems: [String] // List of selected items
    var missingItems: [String] // List of selected items

    var body: some View {
                
        VStack {
            if selectedItems.isEmpty && missingItems.isEmpty{
                Text("No items purchased.")
                    .font(.system(size: 24))
                    .padding()
                
            } else {
                Text("Purchased")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()

                List {
                    ForEach(Array(selectedItems.enumerated()), id: \.offset) { _, item in
                        Text("\(item)") // Numbering each item
                            .padding(.leading)
                            .font(.system(size: 20))
                    }
                }
                .background()
                .cornerRadius(8)
                .shadow(radius: 1) // Optional: Add shadow for depth
                .padding()
                
                Text("Missed Items")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                List {
                    ForEach(Array(missingItems.enumerated()), id: \.offset) { _, item in
                        Text("\(item)") // Numbering each item
                            .padding(.leading)
                            .font(.system(size: 20))
                    }
                }
                .background()
                .cornerRadius(8)
                .shadow(radius: 1) // Optional: Add shadow for depth
                .padding()
            }

            
        }

        .navigationTitle("Home")
    }
}

#Preview {
    DetailView(selectedItems: ["Apples", "Bananas", "Carrots"], missingItems:["Oranges", "Eggs"])
        .frame(width: 400, height: 600)
}
