//
//  GroceryRepeatAlertView.swift
//  GroceryCart
//
//  Created by Charline on 2024/9/4.
//

import SwiftUI

struct GroceryRepeatAlertView: View {
    var message: String
    var onDismiss: () -> Void
    
    var body: some View {
        VStack {
            Text(message)
                .font(.headline)
                .padding()
            Button("OK") {
                onDismiss()
            }
            .padding()
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

#Preview {
    GroceryRepeatAlertView( message: "This item is already in today's list.",
                            onDismiss: { })
    .frame(width: 400, height: 600)
}
