//
//  Color.swift
//  Phoenix Insurance
//
//  Created by Soft Minders on 25/01/25.
//

import SwiftUI

extension Color {
    // Initializer to create a Color from a hex code string
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if hexSanitized.hasPrefix("#") {
            hexSanitized = String(hexSanitized.dropFirst())
        }
        
        var rgba: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgba)
        
        let red = Double((rgba & 0xFF0000) >> 16) / 255.0
        let green = Double((rgba & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgba & 0x0000FF) / 255.0
        let alpha = hexSanitized.count == 8 ? Double((rgba & 0xFF000000) >> 24) / 255.0 : 1.0
        
        self.init(red: red, green: green, blue: blue, opacity: alpha)
    }
}
