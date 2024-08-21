//
//  ContentView.swift
//
//  Created by Charline on 2024/8/19.
//

import SwiftUI

struct ContentView: View {
    @State private var inputText: String = "" // type what to buy
    @State private var words: [String] = [] // List of need to buy items
    @State private var selectedItems: [String] = [] // List of already bought items
    @State private var missingItems: [String] = [] // List of missing items

    var body: some View {
        NavigationStack {
            VStack {
                // title
                HStack {
                    Text("Grocery Cart")
                        .font(.system(size: 32, weight: .bold))
                    
                    Image(systemName: "cart.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                        .foregroundColor(.black)
                }
                .padding(.top)
                
                // type what to buy
                HStack {
                    TextField("Items to Buy", text: $inputText)
                        .font(.system(size: 22))
                    
                    Button(action: {
                        // Add the grocery to the list
                        if !inputText.isEmpty {
                            words.append(inputText)
                            inputText = "" // Clear the input field after adding
                        }
                    }) {
                        // plus icon
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 25)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background()
                .cornerRadius(8)
                .shadow(radius: 1) // Optional: Add shadow for depth
                
                // list groceries
                List {
                    ForEach(Array(words.enumerated()), id: \.offset) { _, word in
                        HStack {
                            Image(systemName: "circle.fill")
                            
                            Text("\(word)") // Numbering each item
                                .padding(.leading)
                                .font(.system(size: 20))
                            
                            Spacer()
                            
                            // already buy item
                            Button(action: {
                                // move to history
                                if let index = words.firstIndex(of: word) {
                                    // items will move to history
                                    selectedItems.append(word)
                                    // remove already bought item
                                    words.remove(at: index)
                                }
                            }) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .frame(width: 24, height: 24)
                                    .background(Color.white)
                            }
                            
                            // delete item (for no need grocery)
                            Button(action: {
                                // Remove the tapped item from the list
                                if let index = words.firstIndex(of: word) {
                                    words.remove(at: index)
                                }
                            }) {
                                Image(systemName: "minus.circle")
                                    .foregroundColor(.red)
                                    .frame(width: 24, height: 24)
                                    .background()
                            }
                        }
                    }
                }
                .padding()
                .background()
                .cornerRadius(8)
                .shadow(radius: 1)
                
                HStack {
                    // finish shopping (clear the shopping cart
                    Button("Finish Shopping") {
                        if !words.isEmpty {
                            for word in words {
                                missingItems.append(word)
                            }
                            words = []
                        }
                    }
                    
                    // go to History List page
                    NavigationLink(destination: DetailView(selectedItems: selectedItems, missingItems: missingItems)) {
                        Text("Check History")

                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
        .frame(width: 400, height: 600)
}
