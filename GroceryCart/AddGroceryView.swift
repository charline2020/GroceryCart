//
//  AddGroceryView.swift
//  GroceryCart
//
//  Created by Charline on 2024/8/23.
//

import SwiftUI


struct AddGroceryView: View {
    @State private var groceryName: String = ""
    @State private var groceryAmount: Int = 1
    @State private var purchasedItems: Set<UUID> = [] // Track purchased items by their IDs
    @EnvironmentObject var historyManager: GroceryHistoryManager
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    @State private var alertMessage: String = ""


    var body: some View {
        NavigationStack {
            VStack {
                // title
                HStack {
                    Text("Grocery Cart")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color(hex:"#EF7B45"))

                    Image(systemName: "cart.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
//                        .foregroundColor(.black)
                        .foregroundColor(Color(hex:"#EF7B45"))
                }
                
                // type what to buy
                HStack {
                    TextField("Enter grocery item", text: $groceryName)
                        .font(.system(size: 22))
                    
                    // type amount of the item
                    Stepper(value: $groceryAmount, in: 1 ... 100) {
                        Text("# \(groceryAmount)")
                            .font(.system(size: 20))
                    }
                    
                    Button(action: {
                        guard !groceryName.isEmpty else {
                                return // Do nothing if groceryName is empty
                            }
                        
                        let newItem = GroceryItem(name: groceryName, amount: groceryAmount, date: Date())
                        
                            
                        if historyManager.addItem(newItem) {
                            groceryName = ""
                            groceryAmount = 1 // Reset to default amount
                        } else {
                            alertMessage = "This item is already in today's list."
                            showAlert = true
                        }
                    })
                    {
                        
                        // plus icon
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 25)
                            .foregroundColor(.gray)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Alert"),
                            message: Text(alertMessage)
//                            dismissButton: .default(Text("OK"))
                        )}
                    
                }
                .background()
//                .overlay(
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(.gray, lineWidth: 2)
//                        .shadow(radius: 1)
//                        .foregroundColor(.white)
//                )
                
                // list all grocery
                List {
                    VStack {
                        // Header Row
                        HStack {
                            Text("    ")
                            
                            Spacer()
                            
                            Text("Item Name")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.system(size: 16))
                            
                            Spacer()
                            
                            Text("#")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .font(.system(size: 16))
                            
                            Spacer()
                            
                            Text("")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .font(.system(size: 16))
                        }
                        
                        Divider()
                        
                            // List of items
                            ForEach(historyManager.items) { item in
                                HStack {
                                    Image(systemName: "smallcircle.fill.circle.fill")
                                    Text(item.name)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Spacer()
                                    
                                    Text("\(item.amount)")
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                    
                                    Spacer()
                                    
                                    HStack {
                                        // check purchased or not
                                        Button(action: {
                                            togglePurchased(item: item)
                                        }) {
                                            Image(systemName: purchasedItems.contains(item.id) ? "checkmark.circle.fill" : "circle")
                                                .foregroundColor(purchasedItems.contains(item.id) ? .green : .black)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                                                           
                                        Button(action: {
                                            deleteItem(item)
                                        }) {
                                            Image(systemName: "trash") // Delete icon
                                                .foregroundColor(.red)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }
                            
                            
                        
                    }
                }
//                .overlay(
//                    RoundedRectangle(cornerRadius: 4)
//                        .stroke(.gray, lineWidth: 2)
//                        .shadow(radius: 1)
//                )
//                
                HStack {
                    // Button to finish shopping
                    Button(action: {
                        finishShopping()
                    }) {
                        
                        Text("Finish Shopping")
                               
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    // view history
                    NavigationLink(destination: HistoryView()
                        .environmentObject(historyManager))
                    {
                        Text("View History")
                            .foregroundColor(.black)
                    }
//                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .padding()
        }
        .background(Color(hex:"#1C3144"))
    }

    // Function to toggle item purchase status
    private func togglePurchased(item: GroceryItem) {
        if purchasedItems.contains(item.id) {
            purchasedItems.remove(item.id)
        } else {
            purchasedItems.insert(item.id)
        }
    }
    
    // Function to handle item deletion
    private func deleteItem(_ item: GroceryItem) {
        // Remove item from the current grocery list
        historyManager.removeItem(item)
    }
    
    // Function to handle finish shopping
    private func finishShopping() {
        let currentDate = Date().withoutTime()
        
        for item in historyManager.items {
            if purchasedItems.contains(item.id) {
                historyManager.addPurchasedItem(item, date: currentDate) // Ensure this method works
            } else {
                historyManager.addMissingItems([item], date: currentDate) // Ensure this method works
            }
        }
        
        // Clear the current list
        historyManager.items.removeAll()
        purchasedItems.removeAll()
        
        // Save the changes
        historyManager.save()
        
        // Dismiss the view
        presentationMode.wrappedValue.dismiss()
    }
    
    // Computed property to get unique items
    private var uniqueItems: [GroceryItem] {
        var seen = Set<UUID>()
        return historyManager.items.filter { item in
            if seen.contains(item.id) {
                return false
            } else {
                seen.insert(item.id)
                return true
            }
        }
    }
}

#Preview {
    AddGroceryView()
        .environmentObject(GroceryHistoryManager())
        .frame(width: 400, height: 600)
}
