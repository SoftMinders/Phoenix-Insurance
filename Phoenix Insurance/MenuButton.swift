//
//  MenuButton.swift
//  Phoenix Insurance
//
//  Created by Soft Minders on 29/01/25.
//

import SwiftUI

struct MenuButton: View {
    let icon: String
    let title: String
    let action: (() -> Void)? // Make it optional

    var body: some View {
        Button(action: {
            action?() // Call the action only if it's provided
        }) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.white)
                Text(title)
                    .foregroundColor(.white)
                    .font(.body)
                Spacer()
            }
            .padding()
        }
        .background(Color.clear)
        .cornerRadius(8)
    }
}

