//
//  FloatingButtonRow.swift
//  Phoenix Insurance
//
//  Created by Soft Minders on 31/01/25.
//

import SwiftUI
struct FloatingButtonRow: View {
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        HStack {
            Spacer()
            Text(label)
                .font(.headline)
                .foregroundColor(.black)
            
            Button(action: {
                print("\(label) tapped")
            }) {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .padding()
                    .background(color)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
        }
        .padding(.horizontal)
    }
}
